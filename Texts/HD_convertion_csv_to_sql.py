# By Deeplogic
# sql and csv Convertion

import csv
import glob

ENG_TEXT_KEY = 'en_US'

def get_padding_str(length):
    return ('').join([' ', ] * length)

def write_sql(f, texts, max_len, lang=ENG_TEXT_KEY):
    max_len = (max_len + 7) // 4 * 4
    output = ''.join(['-', ] * 80) + '\n-- Language: {}\n'.format(lang)
    padding = get_padding_str(max_len - 3)
    if lang == ENG_TEXT_KEY:
        output += 'insert or replace into EnglishText\n'
        output += '    (Tag,{}Text)\n'.format(padding)
    else:
        lang_max_len = 14
        output += 'insert or replace into LocalizedText\n'
        lang_padding = get_padding_str(lang_max_len - len('Language'))
        output += '    (Language,{}Tag,{}Text)\n'.format(lang_padding, padding)
    output += 'values\n'
    total_items = len(texts)
    for i in range(total_items):
        tag, text = texts[i]
        sep = ',' if i < total_items - 1 else ';'
        output += '    ('
        text = text.replace('"', '""')
        if lang != ENG_TEXT_KEY:
            output += '"{}",{}'.format(lang, get_padding_str(lang_max_len - len(lang) - 2))
        output += '"{}",{}"{}"){}\n'.format(tag, get_padding_str(max_len - len(tag) - 2), text, sep)
    f.write(output + '\n')

def main():
    for g in glob.glob('*Text*.csv'):
        file_name = g[:-4]
        output_name = file_name + '.sql'
        print('Processing {}'.format(g))

        texts = {}
        languages = [ENG_TEXT_KEY]
        texts[ENG_TEXT_KEY] = []
        max_len = 1
        with open(g, 'r') as f:
            reader = csv.reader(f)
            for i, row in enumerate(reader):
                if len(row) == 0:
                    continue
                # print(i, row)
                if i == 0 and row[0] == 'Tag':
                    languages = row[1:]
                    for lang in languages:
                        if lang not in texts:
                            texts[lang] = []
                    
                else:
                    if row[0][:4] == 'LOC_':
                        tag = row[0]
                        max_len = max(max_len, len(tag))
                        for i, content in enumerate(row[1:]):
                            if i < len(languages):
                                lang = languages[i]
                                texts[lang].append((tag, content))

        with open(output_name, 'w', encoding='utf-8') as f:
            if ENG_TEXT_KEY in texts:
                write_sql(f, texts[ENG_TEXT_KEY], max_len)
            for lang in texts.keys():
                if lang != ENG_TEXT_KEY:
                    write_sql(f, texts[lang], max_len, lang)

if __name__ == '__main__':
    main()
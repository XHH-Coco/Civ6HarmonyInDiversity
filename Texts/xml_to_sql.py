# By Deeplogic
# Convert xml text in this folder to sql of the same name (please note the potential overwrite issue)

import glob
from xml.dom.minidom import parse
# import sys
# import codecs
# sys.stdout = codecs.getwriter("utf-8")(sys.stdout.detach())

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
    for g in glob.glob('*Text*.xml'):
        file_name = g[:-4]
        output_name = file_name + '.sql'
        print('Processing {}'.format(g))
        DOMTree  = parse(g)
        collection = DOMTree.documentElement
        replaces = collection.getElementsByTagName("Replace")
        texts = {}
        max_len = 1
        for replace in replaces:
            lang = replace.getAttribute('Language')
            tag = replace.getAttribute('Tag')
            max_len = max(max_len, len(tag))
            text = replace.getElementsByTagName('Text')[0]
            if len(text.childNodes) > 0:
                text = text.childNodes[0].data.lstrip()
            else:
                text = ''
            if lang not in texts:
                texts[lang] = []
            texts[lang].append((tag, text))
        with open(output_name, 'w', encoding='utf-8') as f:
            if ENG_TEXT_KEY in texts:
                write_sql(f, texts[ENG_TEXT_KEY], max_len)
            for lang in texts.keys():
                if lang != ENG_TEXT_KEY:
                    write_sql(f, texts[lang], max_len, lang)

if __name__ == '__main__':
    main()
ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

local BINARY_COMPRESS_MAX_EXP = GlobalParameters.HD_BINARY_COMPRESS_MAX_EXP or 0;
function BinaryCompress(amount, plot, key)
  key = key or 'HD_PLOT_BINARY_COMPRESS';
  local total_key = 'TOTAL_' .. key;

  local pre_total = plot:GetProperty(total_key) or 0;
  if pre_total == amount then
    -- print("二进制折叠 与前值相同 跳过");
    return;
  end
  plot:SetProperty(total_key, amount);

  local num = math.min(amount, math.pow(2, BINARY_COMPRESS_MAX_EXP + 1) - 1)
  print('BinaryCompress start', num)
  for i=BINARY_COMPRESS_MAX_EXP, 0, -1 do
    plot:SetProperty(key .. '_' .. i, 0)
    local divisor = math.pow(2, i)
    if num >= divisor then
      num = num % divisor
      plot:SetProperty(key .. '_' .. i, 1)
      print('BinaryCompress', divisor, plot:GetProperty(key .. '_' .. i))
    end
  end
end
Utils.BinaryCompress = BinaryCompress
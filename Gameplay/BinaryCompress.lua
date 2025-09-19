ExposedMembers.DLHD = ExposedMembers.DLHD or {};
ExposedMembers.DLHD.Utils = ExposedMembers.DLHD.Utils or {};
Utils = ExposedMembers.DLHD.Utils;

local BinaryCompressTag = 'HD_PLOT_BINARY_COMPRESS_';
local BINARY_COMPRESS_MAX_EXP = GlobalParameters.HD_BINARY_COMPRESS_MAX_EXP or 0;
function BinaryCompress(amount, plot, count)
  count = count or 1;
  local num = math.min(amount, math.pow(2, BINARY_COMPRESS_MAX_EXP + 1) - 1)
  print('BinaryCompress start', num)
  for i=BINARY_COMPRESS_MAX_EXP, 0, -1 do
    plot:SetProperty(BinaryCompressTag .. i .. '_' .. count, 0)
    local divisor = math.pow(2, i)
    if num >= divisor then
      num = num % divisor
      plot:SetProperty(BinaryCompressTag .. i .. '_' .. count, 1)
      print('BinaryCompress', divisor, plot:GetProperty(BinaryCompressTag .. i .. '_' .. count))
    end
  end
end
Utils.BinaryCompress = BinaryCompress
require 'optparse'

offset_byte = 56
width_byte_number = 26
header_byte_per_line = 8

opt = OptionParser.new
params = {
  input: nil
}
opt.on('-i VAL') {|v| params[:input] = v }
opt.parse!(ARGV)

if params[:input].nil?
  raise 'Option -i MUST be specified'
end

f = open(params[:input], 'rb')
read_buffer = f.read(offset_byte)
unpacked = read_buffer.unpack("C*")
puts unpacked.map {|x| "%02x" % x}.join
loop do
  read_buffer = f.read(width_byte_number)
  break if read_buffer.nil?
  unpacked = read_buffer.unpack("C*")
  if read_buffer.length == width_byte_number
    unpacked = read_buffer.unpack("C*")
    print unpacked[0, header_byte_per_line].map {|x| "%02x" % x}.join
    print ' '
    puts unpacked[header_byte_per_line, width_byte_number - header_byte_per_line].map {|x| "%08b" % x}.join
  else
    puts unpacked.map {|x| "%02x" % x}.join
  end
end
f.close

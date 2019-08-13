use strict;
use GD;
use GD::Simple;
use IO::Socket::INET;

my $im    = new GD::Image(80,16);
my $white = $im->colorAllocate(255,255,255);
my $black = $im->colorAllocate(0,0,0);

$im->string(gdTinyFont,2,2, $ARGV[0] || scalar(localtime(time())), $black);

my $y = 0;
my $data = [];

while ($y < 16) {
   my $x = 0;
   while ($x < 80) {
      if (scalar($im->rgb($im->getPixel($x,$y)))) {
         print "X";
         $data->[(10*($y))+int($x/8)] |= 2**(7-($x%8));
      } else {
         print " ";
      }
      $x++
   }
   print "\n";
   $y++
}

my $sock = new IO::Socket::INET(
   PeerAddr => "flipdot.lab",
   PeerPort => 2323,
   Proto    => "udp",
   Timeout  => 1) or die("Error opening socket.");

print $sock join("", map { chr($_) } @$data);

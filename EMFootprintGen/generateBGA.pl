# Copyright (c) 2012, Visweswara R (@viswesr). 
# All rights reserved.
#
# You may use this file under the terms of the BSD license as follows
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


# Usage:
# perl generateBGA.pl BGA120 120 13 13 0.25 0.50 6 7 7 0.10 0.0 > BGA120.pac
#
# perl generateBGA.pl BGA112 112 11 11 0.35 0.80 8 10 10 0.13 0.20 > BGA112.pac
#
# perl generateBGA.pl BGA48 48 7 7 0.25 0.50 3 4 4 0.03 0.0 > BGA48.pac

$PackageName    = shift;                                        #"BGA120";
$Pins           = shift;                                        #120;
$Rows           = shift;					#13
$Columns        = shift;					#13
$PadDiameter    = shift;                                        #0.25;
$PadPitch       = shift;                                        #0.5;
$lrPitch        = shift;                                        #6; #left-right
$outlineLength  = shift;                                        #7;
$outlineWidth   = shift;                                        #7;
$StopMargin     = shift;                                        #0.10
$StencilMargin  = shift;                                        #0.0

$skip = sqrt(($Rows *$Columns) - $Pins );  # sqrt(13*13 - 120) = 7
$offset = ($skip - 1) /2 ;

$mid = ($Rows + 1) /2 ;


print '<package name="' . "$PackageName" . '">' . "\n";

$i=0;
$j=0;

$X1= -($lrPitch / 2);
$Y1=   $lrPitch / 2;

$skipi =0;
for($i = 1; $i <=$Columns; $i++)
{
    $Y1=   $lrPitch / 2;
    for($j = 1; $j <=$Rows ; $j++)
    {
        if( ($i>= ($mid - $offset) &&  $i<= ($mid + $offset)) &&
            ($j>= ($mid - $offset) &&  $j<= ($mid + $offset))
          )
          {
             
          }
          else
          { 
          if($j >8) {$skipi =1} else {$skipi = 0};

	  print '<smd name="'
	  .chr($j+64+$skipi).eval($i). '" x="' . "$X1" . '" y="' . "$Y1"
	  . '" dx="'
	  . "$PadDiameter"
	  . '" dy="'
	  . "$PadDiameter"
	  . '" layer="' . "1"
	  . '" roundness="' . "100"
	  . '" stop="no" cream="no"/>' . "\n";

          print '<circle x="'.eval($X1)
          .'" y="'.eval($Y1)
          .'" radius="'.eval(($PadDiameter+$StopMargin)/2)
          .'" width="0" layer="29"/>'."\n";

          print '<circle x="'.eval($X1)
          .'" y="'.eval($Y1)
          .'" radius="'.eval(($PadDiameter-$StencilMargin)/2)
          .'" width="0" layer="31"/>'."\n";

          }
        $Y1 -= $PadPitch;
    }
$X1 += $PadPitch;

}


$halfOLL = $outlineLength / 2;
$halfOLW = $outlineWidth / 2;
print '<wire x1="'
  . "-$halfOLL"
  . '" y1="'
  . "$halfOLW"
  . '" x2="'
  . "$halfOLL"
  . '" y2="'
  . "$halfOLW"
  . '" width="' . "0.2032"
  . '" layer="' . "51" . '"/>' . "\n";

print '<wire x1="'
  . "$halfOLL"
  . '" y1="'
  . "$halfOLW"
  . '" x2="'
  . "$halfOLL"
  . '" y2="'
  . "-$halfOLW"
  . '" width="' . "0.2032"
  . '" layer="' . "51" . '"/>' . "\n";

print '<wire x1="'
  . "$halfOLL"
  . '" y1="'
  . "-$halfOLW"
  . '" x2="'
  . "-$halfOLL"
  . '" y2="'
  . "-$halfOLW"
  . '" width="' . "0.2032"
  . '" layer="' . "51" . '"/>' . "\n";

print '<wire x1="'
  . "-$halfOLL"
  . '" y1="'
  . "-$halfOLW"
  . '" x2="'
  . "-$halfOLL"
  . '" y2="'
  . "$halfOLW"
  . '" width="' . "0.2032"
  . '" layer="' . "51" . '"/>' . "\n";

print '<wire x1="'
  . eval( -$halfOLL + 0.25 )
  . '" y1="'
  . "$halfOLW"
  . '" x2="'
  . "-$halfOLL"
  . '" y2="'
  . eval( +$halfOLW - 0.25 )
  . '" width="' . "0.2032"
  . '" layer="' . "51" . '"/>' . "\n";

#tPlace layer : chip boundary
print '<wire x1="'
  . "-$halfOLL"
  . '" y1="'
  . "$halfOLW"
  . '" x2="'
  . "$halfOLL"
  . '" y2="'
  . "$halfOLW"
  . '" width="' . "0.2032"
  . '" layer="' . "21" . '"/>' . "\n";

print '<wire x1="'
  . "$halfOLL"
  . '" y1="'
  . "$halfOLW"
  . '" x2="'
  . "$halfOLL"
  . '" y2="'
  . "-$halfOLW"
  . '" width="' . "0.2032"
  . '" layer="' . "21" . '"/>' . "\n";

print '<wire x1="'
  . "$halfOLL"
  . '" y1="'
  . "-$halfOLW"
  . '" x2="'
  . "-$halfOLL"
  . '" y2="'
  . "-$halfOLW"
  . '" width="' . "0.2032"
  . '" layer="' . "21" . '"/>' . "\n";

print '<wire x1="'
  . "-$halfOLL"
  . '" y1="'
  . "-$halfOLW"
  . '" x2="'
  . "-$halfOLL"
  . '" y2="'
  . "$halfOLW"
  . '" width="' . "0.2032"
  . '" layer="' . "21" . '"/>' . "\n";

print '<wire x1="'
  . eval( -$halfOLL + 0.25 )
  . '" y1="'
  . "$halfOLW"
  . '" x2="'
  . "-$halfOLL"
  . '" y2="'
  . eval( +$halfOLW - 0.25 )
  . '" width="' . "0.2032"
  . '" layer="' . "21" . '"/>' . "\n";

$textOffset = 0.254;
print '<text x="'.eval(-$halfOLL).'" y="'.eval($halfOLW+$textOffset).'" size="1.27" align="bottom-left" layer="25">&gt;NAME</text>'."\n";
print '<text x="'.eval(-$halfOLL).'" y="'.eval(-$halfOLW-$textOffset).'" size="1.27" align="top-left" layer="27">&gt;VALUE</text>'."\n";

print '</package>' . "\n";

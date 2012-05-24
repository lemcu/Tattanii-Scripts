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
# perl generateQF.pl PacNum   a b f c c d e Num/4 Num/4 OutL OutW StopMargin StencilMargin X Y Z> PacNum.pac
#
# perl generateQF.pl QFN24    0.80 0.30 3.60 0.65 0.65 5 5 6 6 5 5 0.12 0.10 1.0 1.0 0.5 > QFN24.pac
#
# perl generateQF.pl QFN32    0.80 0.35 4.40 0.65 0.65 6 6 8 8 6 6 0.12 0.10 1.30 1.30 0.50 > QFN32.pac
#
# perl generateQF.pl QFN64    0.85 0.30 7.20 0.50 0.50 8.90 8.90 16 16 9 9 0.12 0.10 2.70 2.70 0.80 > QFN64.pac
#
# perl generateQF.pl QFP48    1.60 0.30 0 0.50 0.50 8.50 8.50 12 12 7 7 0.12 0.1 0 0 0 > QFP48.pac
#
# perl generateQF.pl QFP64    1.60 0.30 0 0.50 0.50 11.50 11.50 16 16 10 10 0.12 0.1 0 0 0 > QFP64.pac
#
# perl generateQF.pl QFP100   1.45 0.30 0 0.50 0.50 15.40 15.40 25 25 14 14 0.12 0.1 0 0 0 > QFP100.pac

$PackageName   = shift;                                          #QFN32;
$PadLength     = shift;                                          #0.80;
$PadWidth      = shift;                                          #0.35;
$EPadSide      = shift;                                          #4.45;
$lrPadPitch    = shift;                                          #0.65;
$tbPadPitch    = shift;                                          #0.65;
$lrPitch       = shift;                                          #6; #left-right
$tbPitch       = shift;                                          #6; #top-bottom
$lrPadCount    = shift;                                          #8; #left-right
$tbPadCount    = shift;                                          #8; #top-bottom
$outlineLength = shift;                                          #6;
$outlineWidth  = shift;                                          #6;
$StopMargin    = shift;                                          #0.12
$StencilMargin = shift;                                          #0.10
$X             = shift;						 #
$Y             = shift;                                          #
$Z             = shift;                                          #

$X1            = -( ( $lrPitch / 2 ) );
$Y1            = ( ( ( $tbPadCount - 1 ) * $tbPadPitch ) / 2 );
$X2       = -( ( ( ( $lrPadCount - 1 ) * $lrPadPitch ) / 2 ) );
$Y2       = -( ( $tbPitch / 2 ) );
$X3       = ( ( $lrPitch / 2 ) );
$Y3       = -( ( ( ( $tbPadCount - 1 ) * $tbPadPitch ) / 2 ) );
$X4       = ( ( ( ( $lrPadCount - 1 ) * $lrPadPitch ) / 2 ) );
$Y4       = ( ( $tbPitch / 2 ) );
$PinCount = 1;
print '<package name="' . "$PackageName" . '">' . "\n";

for ( $i = 1 ; $i <= $tbPadCount ; $i++ )
{
	print '<smd name="'
	  . "$PinCount" . '" x="' . "$X1" . '" y="' . "$Y1"
	  . '" dx="'
	  . "$PadLength"
	  . '" dy="'
	  . "$PadWidth"
	  . '" layer="' . "1"
	  . '" roundness="' . "0"
	  . '" stop="no" cream="no"/>' . "\n";
	print '<rectangle x1="'
	  . eval( $X1 - ( $PadLength / 2 ) - ( $StopMargin / 2 ) )
	  . '" y1="'
	  . eval( $Y1 - ( $PadWidth / 2 ) - ( $StopMargin / 2 ) )
	  . '" x2="'
	  . eval( $X1 + ( $PadLength / 2 ) + ( $StopMargin / 2 ) )
	  . '" y2="'
	  . eval( $Y1 + ( $PadWidth / 2 ) + ( $StopMargin / 2 ) )
	  . '" layer="29"/>' . "\n";
	print '<rectangle x1="'
	  . eval( $X1 - ( $PadLength / 2 ) + ( $StencilMargin / 2 ) )
	  . '" y1="'
	  . eval( $Y1 - ( $PadWidth / 2 ) + ( $StencilMargin / 2 ) )
	  . '" x2="'
	  . eval( $X1 + ( $PadLength / 2 ) - ( $StencilMargin / 2 ) )
	  . '" y2="'
	  . eval( $Y1 + ( $PadWidth / 2 ) - ( $StencilMargin / 2 ) )
	  . '" layer="31"/>' . "\n";
	$Y1 -= ($tbPadPitch);
	$PinCount++;

}
for ( $i = 1 ; $i <= $lrPadCount ; $i++ )
{
	print '<smd name="'
	  . "$PinCount" . '" x="' . "$X2" . '" y="' . "$Y2"
	  . '" dx="'
	  . "$PadWidth"
	  . '" dy="'
	  . "$PadLength"
	  . '" layer="' . "1"
	  . '" roundness="' . "0"
	  . '" stop="no" cream="no"/>' . "\n";
	print '<rectangle x1="'
	  . eval( $X2 - ( $PadWidth / 2 ) - ( $StopMargin / 2 ) )
	  . '" y1="'
	  . eval( $Y2 - ( $PadLength / 2 ) - ( $StopMargin / 2 ) )
	  . '" x2="'
	  . eval( $X2 + ( $PadWidth / 2 ) + ( $StopMargin / 2 ) )
	  . '" y2="'
	  . eval( $Y2 + ( $PadLength / 2 ) + ( $StopMargin / 2 ) )
	  . '" layer="29"/>' . "\n";
	print '<rectangle x1="'
	  . eval( $X2 - ( $PadWidth / 2 ) + ( $StencilMargin / 2 ) )
	  . '" y1="'
	  . eval( $Y2 - ( $PadLength / 2 ) + ( $StencilMargin / 2 ) )
	  . '" x2="'
	  . eval( $X2 + ( $PadWidth / 2 ) - ( $StencilMargin / 2 ) )
	  . '" y2="'
	  . eval( $Y2 + ( $PadLength / 2 ) - ( $StencilMargin / 2 ) )
	  . '" layer="31"/>' . "\n";
	$X2 += ($lrPadPitch);
	$PinCount++;

}
for ( $i = 1 ; $i <= $tbPadCount ; $i++ )
{
	print '<smd name="'
	  . "$PinCount" . '" x="' . "$X3" . '" y="' . "$Y3"
	  . '" dx="'
	  . "$PadLength"
	  . '" dy="'
	  . "$PadWidth"
	  . '" layer="' . "1"
	  . '" roundness="' . "0"
	  . '" stop="no" cream="no"/>' . "\n";
	print '<rectangle x1="'
	  . eval( $X3 - ( $PadLength / 2 ) - ( $StopMargin / 2 ) )
	  . '" y1="'
	  . eval( $Y3 - ( $PadWidth / 2 ) - ( $StopMargin / 2 ) )
	  . '" x2="'
	  . eval( $X3 + ( $PadLength / 2 ) + ( $StopMargin / 2 ) )
	  . '" y2="'
	  . eval( $Y3 + ( $PadWidth / 2 ) + ( $StopMargin / 2 ) )
	  . '" layer="29"/>' . "\n";
	print '<rectangle x1="'
	  . eval( $X3 - ( $PadLength / 2 ) + ( $StencilMargin / 2 ) )
	  . '" y1="'
	  . eval( $Y3 - ( $PadWidth / 2 ) + ( $StencilMargin / 2 ) )
	  . '" x2="'
	  . eval( $X3 + ( $PadLength / 2 ) - ( $StencilMargin / 2 ) )
	  . '" y2="'
	  . eval( $Y3 + ( $PadWidth / 2 ) - ( $StencilMargin / 2 ) )
	  . '" layer="31"/>' . "\n";
	$Y3 += ($tbPadPitch);
	$PinCount++;

}
for ( $i = 1 ; $i <= $lrPadCount ; $i++ )
{
	print '<smd name="'
	  . "$PinCount" . '" x="' . "$X4" . '" y="' . "$Y4"
	  . '" dx="'
	  . "$PadWidth"
	  . '" dy="'
	  . "$PadLength"
	  . '" layer="' . "1"
	  . '" roundness="' . "0"
	  . '" stop="no" cream="no"/>' . "\n";
	print '<rectangle x1="'
	  . eval( $X4 - ( $PadWidth / 2 ) - ( $StopMargin / 2 ) )
	  . '" y1="'
	  . eval( $Y4 - ( $PadLength / 2 ) - ( $StopMargin / 2 ) )
	  . '" x2="'
	  . eval( $X4 + ( $PadWidth / 2 ) + ( $StopMargin / 2 ) )
	  . '" y2="'
	  . eval( $Y4 + ( $PadLength / 2 ) + ( $StopMargin / 2 ) )
	  . '" layer="29"/>' . "\n";
	print '<rectangle x1="'
	  . eval( $X4 - ( $PadWidth / 2 ) + ( $StencilMargin / 2 ) )
	  . '" y1="'
	  . eval( $Y4 - ( $PadLength / 2 ) + ( $StencilMargin / 2 ) )
	  . '" x2="'
	  . eval( $X4 + ( $PadWidth / 2 ) - ( $StencilMargin / 2 ) )
	  . '" y2="'
	  . eval( $Y4 + ( $PadLength / 2 ) - ( $StencilMargin / 2 ) )
	  . '" layer="31"/>' . "\n";
	$X4 -= ($lrPadPitch);
	$PinCount++;

}
if($EPadSide > 0)
{
print '<smd name="'
  . "$PinCount" . '" x="' . "0" . '" y="' . "0"
  . '" dx="'
  . "$EPadSide"
  . '" dy="'
  . "$EPadSide"
  . '" layer="' . "1"
  . '" roundness="' . "0"
  . '" stop="no" cream="no"/>' . "\n";
print '<rectangle x1="'
  . eval( 0 - ( $EPadSide / 2 ) - ( $StopMargin / 2 ) )
  . '" y1="'
  . eval( 0 - ( $EPadSide / 2 ) - ( $StopMargin / 2 ) )
  . '" x2="'
  . eval( 0 + ( $EPadSide / 2 ) + ( $StopMargin / 2 ) )
  . '" y2="'
  . eval( 0 + ( $EPadSide / 2 ) + ( $StopMargin / 2 ) )
  . '" layer="29"/>' . "\n";

print '<rectangle x1="'
  . eval(-($Y + $Z/2))
  . '" y1="'
  . eval( ($X + $Z/2) )
  . '" x2="'
  . eval(-($Z/2))
  . '" y2="'
  . eval(($Z/2) )
  . '" layer="31"/>' . "\n";

print '<rectangle x1="'
  . eval(-($Y + $Z/2))
  . '" y1="'
  . eval(-($X + $Z/2) )
  . '" x2="'
  . eval(-($Z/2))
  . '" y2="'
  . eval(-($Z/2) )
  . '" layer="31"/>' . "\n";

print '<rectangle x1="'
  . eval(($Y + $Z/2))
  . '" y1="'
  . eval(-($X + $Z/2) )
  . '" x2="'
  . eval(+($Z/2))
  . '" y2="'
  . eval(-($Z/2) )
  . '" layer="31"/>' . "\n";

print '<rectangle x1="'
  . eval(($Y + $Z/2))
  . '" y1="'
  . eval(($X + $Z/2) )
  . '" x2="'
  . eval(($Z/2))
  . '" y2="'
  . eval(($Z/2) )
  . '" layer="31"/>' . "\n";
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
  . eval( -$halfOLL + 0.20 )
  . '" y1="'
  . "$halfOLW"
  . '" x2="'
  . "-$halfOLL"
  . '" y2="'
  . eval( +$halfOLW - 0.20 )
  . '" width="' . "0.2032"
  . '" layer="' . "51" . '"/>' . "\n";

$halfOLExtent = ( ($lrPadPitch * ($lrPadCount-1)) + $PadWidth) / 2 ;
$OLExtent =  $halfOLL - $halfOLExtent - 0.1016 - ( $StencilMargin / 2 );

#tPlace layer : chip boundary
#(-,+)
print '<wire x1="'
  . "-$halfOLL"
  . '" y1="'
  . "$halfOLW"
  . '" x2="'
  . eval(-$halfOLL+$OLExtent)
  . '" y2="'
  . eval(+$halfOLW)
  . '" width="' . "0.2032"
  . '" layer="' . "21" . '"/>' . "\n";

print '<wire x1="'
  . "-$halfOLL"
  . '" y1="'
  . "$halfOLW"
  . '" x2="'
  . eval(-$halfOLL)
  . '" y2="'
  . eval(+$halfOLW-$OLExtent)
  . '" width="' . "0.2032"
  . '" layer="' . "21" . '"/>' . "\n";

#(+,+)
print '<wire x1="'
  . "$halfOLL"
  . '" y1="'
  . "$halfOLW"
  . '" x2="'
  . eval($halfOLL-$OLExtent)
  . '" y2="'
  . eval($halfOLW)
  . '" width="' . "0.2032"
  . '" layer="' . "21" . '"/>' . "\n";

print '<wire x1="'
  . "$halfOLL"
  . '" y1="'
  . "$halfOLW"
  . '" x2="'
  . eval($halfOLL)
  . '" y2="'
  . eval($halfOLW-$OLExtent)
  . '" width="' . "0.2032"
  . '" layer="' . "21" . '"/>' . "\n";


#(+,-)0
print '<wire x1="'
  . "$halfOLL"
  . '" y1="'
  . "-$halfOLW"
  . '" x2="'
  . eval($halfOLL-$OLExtent)
  . '" y2="'
  . eval(-$halfOLW)
  . '" width="' . "0.2032"
  . '" layer="' . "21" . '"/>' . "\n";

print '<wire x1="'
  . "$halfOLL"
  . '" y1="'
  . "-$halfOLW"
  . '" x2="'
  . eval($halfOLL)
  . '" y2="'
  . eval(-$halfOLW+$OLExtent)
  . '" width="' . "0.2032"
  . '" layer="' . "21" . '"/>' . "\n";

#(-,-)
print '<wire x1="'
  . "-$halfOLL"
  . '" y1="'
  . "-$halfOLW"
  . '" x2="'
  . eval(-$halfOLL+$OLExtent)
  . '" y2="'
  . eval(-$halfOLW)
  . '" width="' . "0.2032"
  . '" layer="' . "21" . '"/>' . "\n";

print '<wire x1="'
  . "-$halfOLL"
  . '" y1="'
  . "-$halfOLW"
  . '" x2="'
  . eval(-$halfOLL)
  . '" y2="'
  . eval(-$halfOLW+$OLExtent)
  . '" width="' . "0.2032"
  . '" layer="' . "21" . '"/>' . "\n";

#slash
print '<wire x1="'
  . eval( -$halfOLL + $OLExtent )
  . '" y1="'
  . "$halfOLW"
  . '" x2="'
  . "-$halfOLL"
  . '" y2="'
  . eval( +$halfOLW - $OLExtent )
  . '" width="' . "0.2032"
  . '" layer="' . "21" . '"/>' . "\n";

$textOffset = 0;
if($EPadSide > 0)
{
    $textOffset = ($PadLength/2) + 0.254;
}
else
{
    $textOffset = $PadLength + 0.254;
}
print '<text x="'.eval(-$halfOLL).'" y="'.eval($halfOLW+$textOffset).'" size="1.27" align="bottom-left" layer="25">&gt;NAME</text>'."\n";
print '<text x="'.eval(-$halfOLL).'" y="'.eval(-$halfOLW-$textOffset).'" size="1.27" align="top-left" layer="27">&gt;VALUE</text>'."\n";

print '</package>' . "\n";

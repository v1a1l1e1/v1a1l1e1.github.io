#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

#ifdef __DEBUG

DefineIAction(Dlight)
 execAction
{
  if(gPlayerChar.brightness == 0)
  {
    "You start to glow!\n";
    gPlayerChar.brightness = 3;
  }
  else
  {
    "Repeating the spell reverses its effect, and your glowing aura disappears. ";
    gPlayerChar.brightness = 0;
  }
}
;

VerbRule(Dlight)
  'dlight'
  : DlightAction
  verbPhrase = 'make/making light'
;

#endif

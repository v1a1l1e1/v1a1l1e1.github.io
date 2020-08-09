#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

class Deck : ShipboardRoom, OutdoorRoom
	roomParts = [defaultDeck, caveSky]
	cannotGoThatWay(){
		if(gAction.parentAction.dirMatch.dir.ofKind(CompassDirection))
			"Compass directions aren't that useful for getting about ship; try fore, aft, port and starboard instead. ";
		else
			inherited;
	}
;
class Cabin : ShipboardRoom, Room
	roomBeforeAction(){
		if (gActionIs(Jump)){
			"{You/he} had better not try jumping here, {you/he} might hit {your} head on the deck beams. ";
			exit;
		}
	}
	roomAfterAction(){
		if (gActionIs(Look)){
			creacking.doScript();
		}
	}
	creacking: CyclicEventList{
		[
		'\nThe ship creaks ominously.\n',
		'\nThe creacking sound of the ship makes {you/he} shiver.\n'
		]
	}
	roomParts = [
	defaultDeck,
	defaultCeiling,
	defaultForeBulkhead,
	defaultAftBulkhead,
	defaultPortWall,
	defaultStarboardWall
	]
;
class DarkCabin : Cabin
  brightness = 0
;

class Tablet : Readable
  desc = "\^<<theName>> is about eight inches square and an inch thick. <<readDesc>>"
	readDesc = "On it is inscribed:\b<FONT FACE='TADS-Typewriter'><<inscription>></FONT>\b"
  bulk = 4
;

class RedCandle : Dispensable, Candle 'red candle*candles' 'red candle'
  "It's a long red candle. "
  isEquivalent = true
  isListedInContents = (!isIn(myDispenser))
  myDispenser = candleBox
;


modify Room
	roomDesc(){inherited; extras;}
	extras(){
		if (contents.length == 0) return;
		local cur;
		local vec = new Vector(10);
		foreach (cur in contents)
			if (cur.propType(&inRoomDesc) is in (TypeDString,TypeCode))
				vec.append(cur);
		if (vec.length==0) return;
		vec = vec.sort(nil, {a,b : a.inRoomDescOrder - b.inRoomDescOrder});
		foreach(cur in vec)
			if(gPlayerChar.canSee(cur))
				cur.inRoomDesc;
		}
		finalDesc = nil
	;

modify Thing
	inRoomDesc = nil
	inRoomDescOrder = 100
	dobjFor(GoBehind){
		verify(){
			illogical('{You/he} can\'t go behind {that dobj/him}. ');
		}
	}
;
modify SpaceOverlay
  okayTakeMsg = '{You/he} take{s} {the dobj/him}. '
;

DefineTAction(GoBehind)
;

VerbRule(GoBehind)
	('go' | 'stand' | 'walk') 'behind' singleDobj
	: GoBehindAction
	verbPhrase = 'go/going (behind what)'
;

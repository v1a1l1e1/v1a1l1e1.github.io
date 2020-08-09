#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

function endGame(msg){
  finishGameMsg(msg, [finishOptionUndo, finishOptionFullScore]);
}

defaultDeck : Floor
	'deck/ground/floor'
	'deck'
	"The deck is made of close-fitting wooden planks. "
	putDestMessage = &putDestFloor
;

caveSky : RoomPart
	'roof/ceiling'
	'ceiling'
	"The dark roof of the cave, a long way up, dimly reflects the rippling green light from the lake. "
;

defaultForeBulkhead : RoomPart
'f fore foreward bulkhead/wall*walls'
'foreward bulkhead';

defaultAftBulkhead : RoomPart
'a aft bulkhead/wall*walls'
'aft bulkhead';

defaultPortWall : RoomPart
'p port wall*walls'
'port wall';

defaultStarboardWall : RoomPart
'sb starboard wall*walls'
'starboard wall';

greatCabinForeBulkhead : defaultForeBulkhead
  desc = "The foreward bulkhead is made of polished oak planks.
    <<bulkheadDoor.isOpen ? bulkheadDoor.desc : nil>> "
;

greatCabinAftBulkhead : defaultAftBulkhead
  desc = "The aft wall of the cabin is pierced by a series of windows across most of its width. "
;


ship : Enterable ->portDeck
	'large wooden sailing ship'
	'ship'
	@lakeRoom
  "It's a large wooden sailing ship, close enough to the shore to board. "
  specialDesc = "A large wooden ship floats on the lake, just by the shore. "
  dobjFor(Board) asDobjFor(Enter)
  getFacets { return [leaveShip]; }
;
+ leaveShip : Exitable ->(ship.location) 'ship' 'ship'
  "It's a large wooden sailing vessel, which stretches fore, aft and to starboard of the port deck. "
   getFacets { return [ship]; }
;

portDeck : Deck 'Port Deck' 'the main deck'
   "This part of the main deck is on the port side of the ship, close to the shore. The deck continues to fore, aft and starboard, and a tall mast towers up from the middle of the main deck. "
    fore = foreDeck
    aft = quarterDeck
    starboard = starboardDeck
    out = (ship.location)
    up = mast
;

starboardDeck : Deck 'Starboard Deck' 'the main deck'
  "From the starboard side of the ship there's a clear view over the lake as far as the eye can see to starboard. The deck continues forward, aft and to port, and a tall  mast rises up from the centre of the main deck. "
   port = portDeck
   fore = foreDeck
   aft = quarterDeck
   up = mast
;

mainDeck : OneWayRoomConnector
  destination = portDeck
;

mast : MultiLoc, StairwayUp 'tall thick wooden mast' 'tall mast'
  "The thick wooden mast towers up at least a hundred feet. "
  locationList = [portDeck, starboardDeck]
;

topOfMast : Floorless, Deck 'Top of Mast' 'the top of the mast'
  "From the top of the mast you can see miles out across the lake to starboardand the shore over to port. The deck below looks a sickeningly long way down. "
   down = mainDeck
   bottomRoom = (mainDeck.destination)
;
+ StairwayDown ->mast 'mast' 'mast'
  "Right now you're clinging to it for dear life. "
  dobjFor(TravelVia) remapTo(TravelVia, mainDeck)
;

foreDeck : Deck 'Fore Deck' 'the fore deck'
  "The foredeck is at the front of the ship, overlooking the bows. Most of the
  ship is aft from here. "
  aft = mainDeck
;

quarterDeck : Deck 'Quarterdeck' 'the quarterdeck'
  "The quarterdeck is a raised portion of the deck near the stern of the ship, and separated from the deck further foreward by a wooden rail on which is mounted a panel. A flight of steps leads down below. "
   fore = portDeck
	 port = portDeck
	 starboard = starboardDeck
   down = deckSteps
;

+ deckSteps : StairwayDown 'flight steps' 'steps'
  "The steps lead down into a cabin below. "
  isPlural = true
;

greatCabin : Cabin 'Great Cabin' 'the great cabin'
  "The great cabin occupies the entire width of the ship at the stern. The stern windows aft look out over the water, while there is a solid wooden bulkhead foreward and a flight of steps leads up to the deck above. "
  up = cabinSteps
  fore = bulkheadDoor
	roomParts = static inherited - defaultAftBulkhead -defaultForeBulkhead + greatCabinAftBulkhead + greatCabinForeBulkhead
;
+ cabinSteps : StairwayUp -> deckSteps 'flight steps' 'steps'
  "The steps lead up to the deck above. "
  isPlural = true
;
+ bulkheadDoor : HiddenDoor 'bulkhead door/doorway/opening' 'bulkhead door'
  "The central section of the foreward bulkhead has slid open, revealing a doorway through the bulkhead. "
  destination = crewQuarters
;
crewQuarters : DarkCabin 'Crew Quarters' 'the crew quarters'
  "The crew quarters seem largely deserted, apart from a single locker fixed to the bulkhead. There's an exit back aft and a ladder leading down into the hold. Another exit leads foreward. "
   down = holdLadderDown
   aft = greatCabin
	 fore = galley
	 cannotGoThatWayInDark()  {darkEvents.doScript(); }
	 roomDarkTravel(actor){
	 		cannotGoThatWayInDark;
	 		exit;
 	 }
	 darkEvents : StopEventList {
 	 	[
	 		'Blundering about a ship in the dark could prove dangerous. ',
		new function{
			"Blundering around in the dark you fall down a ladder into the hold and break your neck. ";
		 	endGame(ftDeath);
	 		}
 		]
	}
	enteringRoom (traveler){darkEvents.curScriptState = 1;}
;
+ holdLadderDown : StairwayDown 'ladder' 'ladder';

hold : DarkCabin 'Hold'
  "The hold seems vast and cavernous, and is largely empty. A ladder leads up through an open hatchway above. "
   up = holdLadderUp
;
+ holdLadderUp : StairwayUp ->holdLadderDown 'ladder' 'ladder';

galley : DarkCabin 'Galley' 'the galley'
  "It looks like the galley has been more or less stripped bare. There's a work surface with a cupboard underneath it, and not much else. "
  aft = crewQuarters
;

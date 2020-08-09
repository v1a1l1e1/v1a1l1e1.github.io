#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// FIXTURE - IMMOVABLE
Decoration 'red sign*signs' 'red sign' @entranceCave
 "\n<CENTER><FONT COLOR=WHITE BGCOLOR=RED FACE='Tads-Typewriter'>WAY OUT -></FONT></CENTER>\n"
  dobjFor(Read) asDobjFor(Examine)
;

Decoration 'blue sign*signs' 'blue sign' @entranceCave
  "\n<CENTER><FONT BGCOLOR=BLUE COLOR=WHITE FACE='TADS-Typewriter'>
   WELCOME TO&ensp;THE\nEERHTSDAT CAVES</FONT></CENTER>\n"
   dobjFor(Read) asDobjFor(Examine)
;

Fixture 'torch' 'torch' @mainCave
  "The torch, which is fixed firmly to wall by a steel bracket, is blazing merrily, its flames casting a bright but flickering light over the cave. "
  cannotTakeMsg = 'It\'s fixed to the wall. '
;

bracket: RoomPartItem, Decoration 'steel bracket' 'steel bracket' @mainCave
  "The steel bracket is fixed securely to the wall; there doesn't appear to be any way it could be detached. "
	specialNominalRoomPartLocation = defaultNorthWall
	specialDesc = "A steel bracket containing a flaming torch is fixed to the wall. "
;

fakeTreasure : Thing 'huge great golden gold banana/treasure' 'golden banana' @mainCave
  "It's a fantastic treasure, over two feet long, and by the look of it, solid gold. It must be worth an absolute fortune!"
   initSpecialDesc = "A huge treasure - a great golden banana - lies on the ground. "
   dobjFor(Take){
     action(){
       "All that glisters is not gold, and as you try to take the great golden banana it crumbles into dust and vanishes away. ";
       noTreasure.moveInto(location);
       moveInto(nil);
     }
   }
   getFacets() { return [noTreasure]; }
;

noTreasure : Unthing  'huge great golden gold treasure/banana/dust' 'golden banana'
  'The illusory golden banana vanished into fine dust that is no longer visible. '
;

longCaveWords : Decoration 'words/writing' 'words' @longCave
  "The writing on the wall declares:\b<q>One banana to rule them all\nAnd in the darkness bind them.</q>"
   isPlural = true
   notImportantMsg = 'That\'s not the sort of thing you can do to them. '
   dobjFor(Read) asDobjFor(Examine)
   initNominalRoomPartLocation = defaultSouthWall
;

rug : Immovable 'large rectangular chinese rug/pattern/leaves/dragons' 'Chinese rug' @roundCave
  "The rectangular rug is patterned in pastel colours, mainly turquoise round the edge and principally golds and browns within. The patterns consists mainly of leaves and dragons. "
  initSpecialDesc = "A Chinese rug covers the centre of the floor. "
  specialDesc = "The Chinese rug has been pulled over to one side of the cave. "
  cannotTakeMsg = 'You probably could roll the carpet up and drag it around, but you don\'t want to be encumbered with it. '
  dobjFor(Pull) {
    action() {
      if(moved)
        "You can't pull the rug any further, it's already at the edge of the cave. ";
      else {
        "Pulling the rug over to the edge of the cave reveals a square hole in the floor. ";
        moved = true;
      }
    }
  }
;




MultiLoc, Decoration 'great (giant) underground lake/water' 'lake'
  "The lake, which stretches as far south as you can see, looks almost as flat as a millpond, although the occasional ripple runs across its surface. It is also strikingly phosphorescent, casting an eerie green glow over the whole vast cavern. "
  locationList = [lakeRoom, pathEnd]
;

Fixture 'wooden (deck) rail' 'deck rail' @quarterDeck
  "The wooden deck rail runs along the forward edge of the Quarterdeck, separating it from the main deck, although it is possible to get round the rail either to starboard or port to go foreward. A large wooden panel is fixed to the centre of the rail. "
;
+ Component 'large wooden panel' 'panel'
  "The panel seems to have something to do with sailing the ship. A wheel and a lever are mounted on it, and between them is a hexagonal aperture. "
;
++ hexHole : RestrictedContainer, Component 'hexagonal hole/aperture' 'hexagonal hole'
   validContents = [hexCrystal]
;

Distant 'great underground lake' 'lake' @topOfMast
  "The lake stretches out to starboard as far as the eye can see; it looks as calm and flat as a millpond. "
;

Distant 'shore' 'shore' @topOfMast
  desc(){
    switch(ship.location) {
      case lakeRoom:
        "The shore to port is a narrow strip of land bounded by the wall of the cave, through which a doorway leads to the north. ";
         break;
      default:
        "The shore is directly on the port side of the ship. ";
    }
  }
;


cabinDesk : Heavy, Surface 'large solid oak desk' 'desk' @greatCabin
  "It's a large, solid oak desk, with a single drawer.  "
	initSpecialDesc = "A large oak desk sits in the middle of the cabin. "
	specialDescOrder = 50
	dobjFor(Open) remapTo(Open, cabinDeskDrawer)
	dobjFor(Close) remapTo(Close, cabinDeskDrawer)
	dobjFor(LookIn) remapTo(LookIn, cabinDeskDrawer)
	iobjFor(PutIn) remapTo(PutIn, DirectObject, cabinDeskDrawer)
	dobjFor(LookUnder) remapTo(LookUnder, underDesk)
	iobjFor(PutUnder) remapTo(PutUnder, underDesk)
	dobjFor(LookBehind) remapTo(LookBehind, deskRear)
	iobjFor(PutBehind) remapTo(PutBehind, DirectObject, deskRear)
	dobjFor(GoBehind) remapTo(GoBehind,deskRear)
;

+ cabinDeskDrawer : OpenableContainer, Component 'drawer' 'drawer'
  bulkCapacity = 4
;
++ tardisKey : Key 'small silver key' 'small silver key';

+ chart : Readable 'chart' 'chart'
	"It appears to be a chart of the lake. "
	readDesc = "According to the chart the lake is roughly circular. There appears to be one landing spot each on the north, south, east and west shores of the lake. "
	initSpecialDesc = "A chart lies on the desk. "
;
+ underDesk : NameAsOther, Underside, Component
	targetObj = cabinDesk
;
++ Hidden, Button, Component 'small brown button' 'small brown button'
  "The small brown button is fixed to the underside of the desk. "
  dobjFor(Push){
    action(){
      "There's a sharp <i>click</i>, and a section of the foreward bulkhead slides
      <<bulkheadDoor.isOpen ? 'closed' : 'open'>>. ";
      bulkheadDoor.makeOpen(!bulkheadDoor.isOpen);
    }
  }
	isListedInContents = (discovered)
;
cabinChair : Chair 'padded chair/cushion' 'chair' @deskRear
	"It's a fine wooden chair with a round back and a padded cushion. "
	initSpecialDesc = "A wooden chair sits behind the desk. "
	bulk = 10
	weight = 7
;

// THINGS
brassCoin : Thing '(small) brassy object' 'small brassy object' @longCave
  "<<described ? nil : 'It turns out to be a coin. '>>
	On the obverse is the head of King Freddie the Fat, and on the reverse is stamped ONE GROAT. "
	initSpecialDesc = "{A coin/he} lies on the ground in a dim corner of the cave. "
   initDesc = "It looks like it might be a coin of some sort. "
	 globalParamName = 'coin'
	 specialDesc = "{A coin/he} lies on the floor. "
	 useSpecialDesc {return location.ofKind(Room) || useInitSpecialDesc();}
	dobjFor(Examine){
		action(){
			if (!described) changeName();
			inherited;
		}
	}
	changeName(){
		name = 'small brass coin';
		cmdDict.removeWord(self, 'object', &noun);
		initializeVocabWith('brass coin/groat*coins');
	}
;

brassTablet : Tablet 'brass tablet*tablets' 'brass tablet' @longCave
	inscription = "F T M T R\nA O O I U\nS T U N L\nT I L R E\nR A D A R"
	initSpecialDesc = "A brass tablet rests by the ladder"
	weight = 4
;

Food '(edible) banana' 'banana' @squareCave
  "It's yellow, about six inches long, and slightly curved. And it looks reasonably fresh. "
  tasteDesc = "It's distinctly banana-flavoured. "
  smellDesc = "It has a kind of faint, fruity smell. "
  feelDesc = "The banana skin feels firm but smooth. "
  soundDesc = "The banana is strangely silent. "
	disambigName = 'edible banana'
  initSpecialDesc = "Someone has left a banana here. "
;

oilCan : Thing 'oil can/oilcan' 'can of oil' @secretPassage
  "It's a can full of oil. "
  initSpecialDesc = "An old oil can lies abandoned on the ground. "
  dobjFor(PourOnto) { verify() { } }
;

diamond : Thing 'sparkling diamond' 'diamond' @pathEnd
  "It looks like the genuine article. "
  iobjFor(CutWith) { verify() { } }
;

diamondRing : Wearable 'diamond ring' 'diamond ring'
  "It's a fine platinum band with a sparkling solitaire diamond. "
  iobjFor(CutWith) { verify() { } }
;

silverCoin : Thing 'small silver coin' 'small silver coin'
  "On the obverse is the head of Queen Fanny the Futile; the reverse is stamped with the words THREE FARTHINGS. "
   location = dressingTable.subSurface
;

ring : Thing 'platinum ring/band/recess' 'platinum ring'
  "It's a plain platinum band, with a small empty recess on one side. "
   location = dressingTable.subContainer
;

// Surface + Container

Surface, Fixture 'narrow ledge' 'narrow ledge' @entranceCave
  "It's about a foot wide and two feet long. "
  bulkCapacity = 25
;
+ firstAidKit : OpenableContainer 'small white first aid box/kit' 'first aid kit'
  "It's made of some kind of white plastic and is about nine inches long. The lid is marked with a broad red cross. "
   initSpecialDesc = "A small white box lies on the ledge. "
   bulkCapacity = 3
   bulk = 4
;
++ syringe : Thing 'syringe' 'syringe';
++ stickingPlaster : Thing 'sticking adhesive plaster' 'sticking plaster';

glassJar : BasicContainer 'glass jar' 'glass jar' @mainCave
  "It seems to be sealed fast. "
  isOpen = nil
  bulkCapacity = 4
  material = glass
	canBeCutBy = [diamond, diamondRing]
	cannotOpenMsg = (isOpen? 'It\'s already open' : '{You/he} can\'t see any way to open it. ')
	notAContainerMsg = iobjMsg(isOpen? 'Now that it\'s been cut open, it won\'t hold anything. ':'There\'s no way {you/he} can put anything inside the sealed jar. ')
	dobjFor(CutWith){
		verify(){
			if (isOpen) illogicalNow('The glass jar has already been cut open. ');
		}
		check(){
			if(canBeCutBy.indexOf(gIobj)==nil)
				failCheck('{You/he} can\'t cut it with {that iobj/him}. ');
		}
		action(){
			"{You/he} cut{s} open the glass jar. ";
			isOpen = true;
		}
	}
;
+ hexCrystal : Thing 'hexagonal blue crystal' 'blue crystal'
  "The crystal is almost cylindrical, except that it has a hexagonal cross-section. It's about eight inches long and pulsates with a faint blue light. "
  brightness = 1
  bulk = 2
  weight = 2
;

cap : Wearable, Container 'sailor\'s cap' 'sailor\'s cap' @locker
  "It's a large round hat with a white top and a small blue peak. "
	bulkCapacity = 3
	isOpen {return !isWorn();}
	iobjFor(PutIn) { preCond = static inherited + objNotWorn }
;

scales : Surface 'large weighing scales/pan/dial/needle' 'scales' @galleyCupboard
	"hese scales comprise a large weighing pan fixed over a square body, on which is a large dial with a needle that is currently pointing to <<reading>>. The numbers round the dial range from 0 to 100, and according to the inscription on the dials the unit of measure is pounds. "
	reading = min((getWeight - weight),100)
	weight = 6
	isPlural = true
	bulk = 10
	bulkCapacity = 50
	iobjFor(PutIn) asIobjFor(PutOn)
	notifyRemove (obj){
		weightMsg = 'As you remove ' + obj.theName;
	}
	notifyInsert (obj,newCont){
		inherited(obj,newCont);
		weightMsg = 'As you put ' + obj.theName + ' ' + newCont.putInName();
	}
	showWeight(){
		"<<weightMsg>> the neddle on the dial swings round to <<reading>>. ";
	}
	afterAction(){
		if (reading !=oldWeight){
			showWeight();
			oldWeight = reading;
		}
	}
	oldWeight = 0
	weightMsg = nil
;

Surface, Fixture 'work surface' 'work surface' @galley;
+ galleyCupboard : OpenableContainer, Fixture '(galley) cupboard' 'cupboard';

locker : LockableContainer, Fixture '(crew) locker' 'locker' @crewQuarters
  "The locker is fixed firmly to the bulkhead. Its door is fastened by a simple latch mechanism, though the latch looks a bit rusty. "
  bulkCapacity = 15
  disambigName = 'crew locker'
  initiallyLocked = true
	makeLocked(stat){
		if (!lockerLatch.oiled){
			reportFailure('The latch is stuck fast. ');
			exit;
		}
		inherited(stat);
	}
;
NameAsOther,SecretFixture targetObj = locker location = crewQuarters;
+ ContainerDoor '(locker) door' 'locker door'
  "The locker door is a plain wooden front, fastened by a latch. "
  subContainer = locker
;
++lockerLatch : Component '(locker) latch' 'latch'
	"he latch looks a bit rusty. It's currently in the <<locker.isLocked ? nil : 'un' >>locked position. "
	iobjFor(PourOnto){
		verify(){}
		action(){
			if(gDobj == oilCan){
				"You pour some oil onto the latch. ";
				oiled = true;
			}
			else
				"It doesn't seem to do much. ";
		}
	}
	dobjFor(Push) asDobjFor(Pull)
	dobjFor(Pull){
		verify(){}
		action(){
			locker.makeLocked(!locker.isLocked);
			"This <<locker.isLocked ? nil : 'un'>>locks the locker. ";
		}
	}
	oiled = nil
	disambigName = 'locker latch'
	dobjFor(Open) remapTo(Open, locker)
	dobjFor(Close) remapTo(Close, locker)
	dobjFor(Lock) remapTo(Lock, locker)
	dobjFor(Unlock) remapTo(Unlock, locker)
;

candleBox : Dispenser 'large green box' 'large green box' @secretPassage
   desc(){
     "The box is ";
     if(contents.length > 10 || candlesCreated < maxCandlesToCreate/2 )
       "full of red candles. "  ;
     else if (contents.length < 1 && candlesCreated == maxCandlesToCreate)
       "empty. ";
     else if(candlesCreated < (3 * maxCandlesToCreate)/4)
       "is about half full of red candles. ";
     else
       "is running out of red candles. ";

   }
   myItemClass = RedCandle
   canReturnItem = true
   initSpecialDesc = "A large green box sits by the wall. "
   notifyRemove(obj){
     if(contents.length < 2 && candlesCreated < maxCandlesToCreate){
       local cur = new RedCandle;
       candlesCreated++;
       cur.moveInto(self);
     }
   }
   candlesCreated = 0
   maxCandlesToCreate = 40
   weight = (2 + maxCandlesToCreate - candlesCreated)
   bulk = 5
   dobjFor(LookIn) asDobjFor(Examine)
;
+RedCandle;

sack : BagOfHolding, StretchyContainer 'coarse brown sack' 'coarse brown sack' @squareCave
  initSpecialDesc = "A coarse brown sack lies crumpled in the corner. "
  bulkCapacity = 3000
  minBulk = 1
	affinityFor(obj){
		return obj.ofKind(Tablet) ? 200 : inherited(obj);
	}
;

// Space Overlay

mirror : RearContainer 'large gilt-framed gilt framed mirror' 'mirror' @anotherCave
	"The mirror is about three foot tall by eighteen inches wide. It is brightly silvered, so that your reflection in it is no more flattering than you would expect. "
  initSpecialDesc = "A large gilt-framed mirror hangs on the wall opposite the dressing table. "
  bulk = 8
  weight = 4
  allowPutBehind = (!moved)
	iobjFor(PutBehind) maybeRemapTo(!moved, PutIn,DirectObject, smallHoleInWall)
;
+ smallHoleInWall : Hidden, Container, Fixture 'small hole' 'small hole'
  "It's just a couple of inches square, and about as deep. "
  specialDesc = "There's a small hole in the wall  opposite the dressing table. "
  initSpecialDesc = "Behind the mirror is a small hole in the wall. "
  bulkCapacity = 2
;

deskRear :  RearContainer,Platform,SecretFixture
	name = 'desk'
	actorInPrep = 'behind'
	actorIntoPrep = 'behind'
	actorOutOfPrep = 'from behind'
	location = greatCabin
	dobjFor(GoBehind){
		verify(){logicalRank(140,'rear');}
		action(){
			gActor.moveIntoForTravel(self);
			defaultReport('{You/he} go{es} behind {the dobj/him} ');
		}
	}
	tryMovingIntoNested(){return tryImplicitAction(GoBehind,self);}
;

smallPicture : RearSurface 'small picture' 'small picture'
  "It's a faded photograph of an eccentrically-dressed man with a long scarf, in company with a smiling young woman with long blonde hair. "
   allowPutBehind = nil
;

++ rightHalfPaper : Hidden, Readable 'right half torn sheet yellow paper*sheets'
  'torn sheet of yellow paper'
  "It looks like the right hand half of a sheet of paper that's been torn in two. It contains a list of names. "
;
++ Decoration 'back/picture/photo/photograph' 'back of the picture'
   dobjFor(Examine) {
     verify() { nonObvious; }
     action() { replaceAction(LookBehind, smallPicture); }
   }
;

dressingTable : ComplexContainer, Heavy  'battered old dressing table' 'dressing table'
  @anotherCave
  "It's battered and scratched, and looks just about on its last legs. In place of drawers, it has a pair of doors attached to the front"
  inRoomDesc = "A battered old dressing table leans drunkenly against a wall of the cave. "
  subSurface : ComplexComponent, Surface { }
  subContainer : ComplexComponent, OpenableContainer {
               bulkCapacity = 5
               openStatus { if(isOpen) ". It's open"; }
             }
  subUnderside : ComplexComponent, Underside { bulkCapacity = 5 }
  subRear : ComplexComponent, RearContainer { bulkCapacity = 5 }
;
+ ContainerDoor '(dressing) (table) door/pair/doors' 'dressing table door'
  "They're made of the same scratched, stained wood as the dressing table to which they're attached, and perfectly match its generally battered appearance. "
  isPlural = true
;

autoRectifier : ComplexContainer 'silver cylinder' 'silver cylinder' @mainCave
  "It's about a foot high and five inches in diameter. A black ring surrounds the opening at one end. The only other feature of interest are a conspicuous
   orange button and the manufacturer's name inscribed just below the ring. "
   subContainer : ComplexComponent, SingleContainer {  bulkCapacity = 3 }
   bulk = 4
   weight = 3
;

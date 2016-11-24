var grammar;

var data = {
  "start": ["#[hero:#character#][villain:#monster#]story#"],
  "story": ["#time.capitalize#, you need #hero.a#. And that #hero# can be very #adj#; so that all you #verb# is #food#. The #hero# is very #adj2#. #p2#"],
  "p2": ["When the #hero# met a #adj# #adj2# #villain# #pron# tries to kill the #villain#. In that #hero.a# can be #adj2#."],
  "time": ["From time to time", "#adv# often", "sometimes"],
  "adv": ["very", "not so", "quite"],
  "character": ["plumber", "cook", "house", "candy", "bear"],
  "adj": ["rough", "posh", "sad", "funny"],
  "adj2": ["useful", "useless", "disturbbing"],
  "food": ['pizza', 'dumplings', 'hamburger', 'ice cream', 'french fries', 'salmon'],
  "monster": ['dragon', 'dinosaur', 'chupacabra', 'jaguar', 'joker', 'voldemort', 'creative coder'],
  "verb": ["need", "deserve", "aspect", "can find", "can eat"],
  "pron": ["he", "she"]
}

function setup()
{
  noCanvas();
  grammar = tracery.createGrammar(data);

  var button = select('#create');
  button.mousePressed(generate);
  var clear = select('#destroy');
  clear.mousePressed(clearAll);
}

function clearAll()
{
  var elements = selectAll('.text');
  for (var i = 0; i < elements.length; i++) {
    elements[i].remove();
  }
}

function generate()
{
  var expansion = grammar.flatten('#start#');
  var par = createP(expansion);
  par.class('text');
}

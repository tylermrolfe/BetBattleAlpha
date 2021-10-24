var toggledGameSelectorID;
var selectedGame;
var selectedType;
var selectedName;
var selectedTeam;

/// Sets the default input value for the range to be 5000
/// Is the primary source for the value of the wager being modified
var value = 5000;


/// Grabs the element for the selected game
/// Grabs the input element from the selected game
/// Creates a string of the range input
/// Sets the html of the selected game to be the existing html plus the range input
/// Updates the name attr to be the wager type
/// Updates the id attr to be the game UUID
function insertSlider(game, type, team) {
	var section = document.getElementById(game + '-' + team);
	var input = section.querySelector("input");
	
	var slider = '<div class="row" id="range-wager"><div class="col-sm-3"></div><div class="col-sm-6"><div class="range-slider" style=\'--min:5000; --max:25000; --step:1000; --value:5000; --text-value:"5000";\' id="amt-slider"> <input id="sliderInput" type="range" min="5000" max="25000" step="1000" value="5000" oninput="this.parentNode.style.setProperty(\'--value\',this.value); value = this.value; this.parentNode.style.setProperty(\'--text-value\', JSON.stringify(this.value))"> <output></output><div class=\'range-slider__progress\'></div></div></div><div class="col-sm-3"> <button type="button" onclick="clicker()" class="btn btn-primary btn-lg btn-block odd-btn addToSlip"><span class="odds-text">ADD TO BET SLIP</span></button></div></div>';
	section.insertAdjacentHTML('afterend', slider);
	//input.name = type;
	//input.id = game;
}

/// Grabs the lone range input from the DOM
/// If an input exists, meaning a range is currently displayed on the screen, grab the input element and remove it from the dom in preparation for the new wager. This acts as a toggle between the games.
/// Inserts a new slider for the new game and wager selected
function wagerSelected(game, type, team, name) {
	
	selectedGame = game;
	selectedType = type;
	selectedName = name;
	selectedTeam = team;
	
	var sliderDiv = document.getElementById("range-wager");
	
	var newId = game + '-' + type;
	
	// Targets the button and removes the active class - a similar operation is performed below
	$('#' + toggledGameSelectorID).removeClass("active")
	/// User tapped the same button to dismiss
	if (newId == toggledGameSelectorID) {
		toggledGameSelectorID = null;
		sliderDiv.remove();			
	/// User tapped on a different button
	} else {
		if (sliderDiv != null) {
			sliderDiv.remove();
		}
		toggledGameSelectorID = newId;
		$('#' + toggledGameSelectorID).addClass("active")
		insertSlider(game, type, team);	
	}
}
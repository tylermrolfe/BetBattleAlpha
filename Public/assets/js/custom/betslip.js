var betInits = [];

function numToDollarAmount(num) {
	const rounded = num.toFixed(2);
	const s = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(rounded);
	return s;
}

function getWinnings(odds, amount) {
	var points = 0;
	if (odds < 0) {
		var a = amount * 100;
		var tw = Math.abs(a/odds);
		points = 0.001 * tw;
	} else {
		var a = amount * odds;
		var tw = a/100;
		points = 0.001 * tw;
	}
	
	return points;
}

class BetInit {	
	constructor(gameId, type, amount, odds, total, team, toWin) {
		this.gameId = gameId;
		this.type = type;
		this.amount = amount;
		this.odds = odds;
		this.total = total;
		this.toWin = getWinnings(this.odds, this.amount).toFixed(2);
	}
	

}

function createBetInit(gameId, type, amount, odds, total) {
	const bet = new BetInit(gameId, type, amount, odds, total, away, home);
	betInits.push(bet);
	
	var top = document.getElementById('betinits');
	var inner = top.innerHTML;
	
	var content = '<div class="d-flex align-items-center justify-content-between py-8"><div class="d-flex flex-column mr-2 align-middle"> <a href="#" class="text-dark-75 slip-bet-text text-hover-primary">' + name + ' '+ odds + '</a> <span class="text-muted">Risk ' + numToDollarAmount(amount) + ' to win ' + toWin + ' Points</span></div> <a href="#" class="btn btn-sm btn-icon btn-circle btn-light-danger"> <i class="ki ki-close icon-xs text-muted"></i> </a></div><div class="separator separator-solid"></div>';
	
	var newInner = inner + content;
	
	top.innerHTML = newInner;
	
	
}

function clicker() {
	var sl = document.getElementById('sliderInput').value;
	console.log(selectedGame);
	console.log(selectedType);
}
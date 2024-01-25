function apply_styles() {
	let button_class = [
		'item-center',
		'rounded-md',
		'bg-zinc-800',
		'shadow-md',
		'text-white',
		'border',
		'border-zinc-700',
		'text-base',
		'px-2',
		'py-1'
	];
	let input_class = button_class;
	let container_class = [
		'rounded-md',
		'shadow-md',
		'text-white',
		'border',
		'border-zinc-700',
		'text-base',
		'py-5'
	];

	let buttons = document.querySelectorAll('button');
	buttons.forEach(button => button.classList.add(...button_class));

	let inputs = document.querySelectorAll('input');
	inputs.forEach(input => input.classList.add(...input_class));

	let containers = document.querySelectorAll('div[container]');
	containers.forEach(container => container.classList.add(...container_class));

	containers = document.querySelectorAll('div[container][focus]');
	containers.forEach(container => {
		container.classList.replace('border-zinc-700', 'border-white')
	});

	let green_cards = document.querySelectorAll('button[color=green]')
	green_cards.forEach(card => {
		card.classList.replace('border-zinc-700', 'border-green-700')
	});

	let red_cards = document.querySelectorAll('button[color=red]')
	red_cards.forEach(card => {
		card.classList.replace('border-zinc-700', 'border-red-700')
	});

	let blue_cards = document.querySelectorAll('button[color=blue]')
	blue_cards.forEach(card => {
		card.classList.replace('border-zinc-700', 'border-blue-700')
	});

	let yellow_cards = document.querySelectorAll('button[color=yellow]')
	yellow_cards.forEach(card => {
		card.classList.replace('border-zinc-700', 'border-yellow-700')
	});
}

apply_styles();

function apply_styles() {
	function update_classlist(selector, callback) {
		let elements = document.querySelectorAll(selector);
		elements.forEach(element => callback(element.classList));
	}
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

	update_classlist('button', list => list.add(...button_class));
	update_classlist('input', list => list.add(...input_class));
	update_classlist('div[container]', list => list.add(...container_class));
	update_classlist('button[disabled]', list => list.remove('bg-zinc-800'));

	function add_border_color(selector, color, opacity = '00') {
		update_classlist(selector, list => {
			list.replace('border-zinc-700', 'border-' + color);
			list.add('shadow-' + color + '/' + opacity);
		});
	}

	add_border_color('div[container][focus]', 'white');
	add_border_color('button[color=green]', 'green-500', '20');
	add_border_color('button[color=red]', 'red-500', '20');
	add_border_color('button[color=blue]', 'blue-500', '20');
	add_border_color('button[color=yellow]', 'yellow-500', '20');
	add_border_color('button[color=wizard]', 'zinc-400', '20');
	add_border_color('button[color=jester]', 'zinc-400', '20');
}

apply_styles();

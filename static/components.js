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

	update_classlist('div[container][focus]', list => list.replace('border-zinc-700', 'border-white'));
	update_classlist('button[color=green]', list => list.replace('border-zinc-700', 'border-green-700'));
	update_classlist('button[color=red]', list => list.replace('border-zinc-700', 'border-red-700'));
	update_classlist('button[color=yellow]', list => list.replace('border-zinc-700', 'border-yellow-700'));
	update_classlist('button[color=blue]', list => list.replace('border-zinc-700', 'border-blue-700'));
	update_classlist('button[disabled][color=green]', list => list.replace('border-green-700', 'border-green-900'));
	update_classlist('button[disabled][color=red]', list => list.replace('border-red-700', 'border-red-900'));
	update_classlist('button[disabled][color=yellow]', list => list.replace('border-yellow-700', 'border-yellow-900'));
	update_classlist('button[disabled][color=blue]', list => list.replace('border-blue-700', 'border-blue-900'));
}

apply_styles();

Shiny.addCustomMessageHandler('waypoint-start', function(opts) {
	window.wps[opts.id] = new Waypoint({
		element: document.getElementById(opts.dom_id),
		handler: function(direction) {
			Shiny.onInputChange(opts.id + "_direction", direction);
			Shiny.onInputChange(opts.id + "_previous", this.previous());
			Shiny.onInputChange(opts.id + "_next", this.next());
		},
		offset: opts.offset
	})
});

Shiny.addCustomMessageHandler('waypoint-destroy', function(opts) {
	window.wps[opts.id].destroy();
});

Shiny.addCustomMessageHandler('waypoint-disable', function(opts) {
	window.wps[opts.id].disable();
});

Shiny.addCustomMessageHandler('waypoint-enable', function(opts) {
	window.wps[opts.id].enable();
});
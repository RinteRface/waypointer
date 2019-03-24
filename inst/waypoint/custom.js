function animateCSS(element, animationName, callback) {
  console.log(element);
  const node = document.getElementById(element)
  node.classList.add('animated', animationName)

  function handleAnimationEnd() {
      node.classList.remove('animated', animationName)
      node.removeEventListener('animationend', handleAnimationEnd)

      if (typeof callback === 'function') callback()
  }

  node.addEventListener('animationend', handleAnimationEnd)
}

Shiny.addCustomMessageHandler('waypoint-start', function(opts) {
	window.wps[opts.id] = new Waypoint({
		element: document.getElementById(opts.dom_id),
		handler: function(direction) {

      if(opts.animate == true)
        animateCSS(opts.dom_id, opts.animation);

			Shiny.onInputChange(opts.id + "_direction", direction);
			Shiny.onInputChange(opts.id + "_previous", this.previous());
			Shiny.onInputChange(opts.id + "_next", this.next());
		},
		offset: opts.offset
	})
});

Shiny.addCustomMessageHandler('waypoint-animate', function(opts) {
	animateCSS(opts.dom_id, opts.animation);
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
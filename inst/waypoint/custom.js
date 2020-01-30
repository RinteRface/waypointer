function animateCSS(element, animationName, callback) {
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
  window.trg[opts.id] = false;
  Shiny.onInputChange(opts.id + "_triggered", window.trg[opts.id]);

	window.wps[opts.id] = new Waypoint({
		element: document.getElementById(opts.dom_id),
		handler: function(direction) {

      window.trg[opts.id] = true;

      if(opts.animate == true)
        animateCSS(opts.dom_id, opts.animation);

			Shiny.onInputChange(opts.id + "_direction:waypointer", direction);
      Shiny.onInputChange(opts.id + "_triggered:waypointer", window.trg[opts.id]);
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

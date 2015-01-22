(function(c,b,a,d){Foundation.libs.dropdown={name:"dropdown",version:"5.2.3",settings:{active_class:"open",align:"bottom",is_hover:false,opened:function(){},closed:function(){}},init:function(f,g,e){Foundation.inherit(this,"throttle");this.bindings(g,e)},events:function(g){var e=this,f=e.S;f(this.scope).off(".dropdown").on("click.fndtn.dropdown","["+this.attr_name()+"]",function(i){var h=f(this).data(e.attr_name(true)+"-init")||e.settings;if(!h.is_hover||Modernizr.touch){i.preventDefault();e.toggle(c(this))}}).on("mouseenter.fndtn.dropdown","["+this.attr_name()+"], ["+this.attr_name()+"-content]",function(k){var j=f(this),l,i;clearTimeout(e.timeout);if(j.data(e.data_attr())){l=f("#"+j.data(e.data_attr()));i=j}else{l=j;i=f("["+e.attr_name()+"='"+l.attr("id")+"']")}var h=i.data(e.attr_name(true)+"-init")||e.settings;if(f(k.target).data(e.data_attr())&&h.is_hover){e.closeall.call(e)}if(h.is_hover){e.open.apply(e,[l,i])}}).on("mouseleave.fndtn.dropdown","["+this.attr_name()+"], ["+this.attr_name()+"-content]",function(i){var h=f(this);e.timeout=setTimeout(function(){if(h.data(e.data_attr())){var j=h.data(e.data_attr(true)+"-init")||e.settings;if(j.is_hover){e.close.call(e,f("#"+h.data(e.data_attr())))}}else{var k=f("["+e.attr_name()+'="'+f(this).attr("id")+'"]'),j=k.data(e.attr_name(true)+"-init")||e.settings;if(j.is_hover){e.close.call(e,h)}}}.bind(this),150)}).on("click.fndtn.dropdown",function(i){var h=f(i.target).closest("["+e.attr_name()+"-content]");if(f(i.target).data(e.data_attr())||f(i.target).parent().data(e.data_attr())){return}if(!(f(i.target).data("revealId"))&&(h.length>0&&(f(i.target).is("["+e.attr_name()+"-content]")||c.contains(h.first()[0],i.target)))){i.stopPropagation();return}e.close.call(e,f("["+e.attr_name()+"-content]"))}).on("opened.fndtn.dropdown","["+e.attr_name()+"-content]",function(){e.settings.opened.call(this)}).on("closed.fndtn.dropdown","["+e.attr_name()+"-content]",function(){e.settings.closed.call(this)});f(b).off(".dropdown").on("resize.fndtn.dropdown",e.throttle(function(){e.resize.call(e)},50));this.resize()},close:function(f){var e=this;f.each(function(){if(e.S(this).hasClass(e.settings.active_class)){e.S(this).css(Foundation.rtl?"right":"left","-99999px").removeClass(e.settings.active_class).prev("["+e.attr_name()+"]").removeClass(e.settings.active_class).removeData("target");e.S(this).trigger("closed",[f])}})},closeall:function(){var e=this;c.each(e.S("["+this.attr_name()+"-content]"),function(){e.close.call(e,e.S(this))})},open:function(f,e){this.css(f.addClass(this.settings.active_class),e);f.prev("["+this.attr_name()+"]").addClass(this.settings.active_class);f.data("target",e.get(0)).trigger("opened",[f,e])},data_attr:function(){if(this.namespace.length>0){return this.namespace+"-"+this.name}return this.name},toggle:function(e){var f=this.S("#"+e.data(this.data_attr()));if(f.length===0){return}this.close.call(this,this.S("["+this.attr_name()+"-content]").not(f));if(f.hasClass(this.settings.active_class)){this.close.call(this,f);if(f.data("target")!==e.get(0)){this.open.call(this,f,e)}}else{this.open.call(this,f,e)}},resize:function(){var f=this.S("["+this.attr_name()+"-content].open"),e=this.S("["+this.attr_name()+"='"+f.attr("id")+"']");if(f.length&&e.length){this.css(f,e)}},css:function(h,g){this.clear_idx();if(this.small()){var f=this.dirs.bottom.call(h,g);h.attr("style","").removeClass("drop-left drop-right drop-top").css({position:"absolute",width:"95%","max-width":"none",top:f.top});h.css(Foundation.rtl?"right":"left","2.5%")}else{var e=g.data(this.attr_name(true)+"-init")||this.settings;this.style(h,g,e)}return h},style:function(h,g,f){var e=c.extend({position:"absolute"},this.dirs[f.align].call(h,g,f));h.attr("style","").css(e)},dirs:{_base:function(e){var f=this.offsetParent(),h=f.offset(),g=e.offset();g.top-=h.top;g.left-=h.left;return g},top:function(f,g){var e=Foundation.libs.dropdown,h=e.dirs._base.call(this,f),i=(f.outerWidth()/2)-8;this.addClass("drop-top");if(f.outerWidth()<this.outerWidth()||e.small()){e.adjust_pip(i,h)}if(Foundation.rtl){return{left:h.left-this.outerWidth()+f.outerWidth(),top:h.top-this.outerHeight()}}return{left:h.left,top:h.top-this.outerHeight()}},bottom:function(f,g){var e=Foundation.libs.dropdown,h=e.dirs._base.call(this,f),i=(f.outerWidth()/2)-8;if(f.outerWidth()<this.outerWidth()||e.small()){e.adjust_pip(i,h)}if(e.rtl){return{left:h.left-this.outerWidth()+f.outerWidth(),top:h.top+f.outerHeight()}}return{left:h.left,top:h.top+f.outerHeight()}},left:function(e,f){var g=Foundation.libs.dropdown.dirs._base.call(this,e);this.addClass("drop-left");return{left:g.left-this.outerWidth(),top:g.top}},right:function(e,f){var g=Foundation.libs.dropdown.dirs._base.call(this,e);this.addClass("drop-right");return{left:g.left+e.outerWidth(),top:g.top}}},adjust_pip:function(k,j){var f=Foundation.stylesheet;if(this.small()){k+=j.left-8}this.rule_idx=f.cssRules.length;var h=".f-dropdown.open:before",g=".f-dropdown.open:after",e="left: "+k+"px;",i="left: "+(k-1)+"px;";if(f.insertRule){f.insertRule([h,"{",e,"}"].join(" "),this.rule_idx);f.insertRule([g,"{",i,"}"].join(" "),this.rule_idx+1)}else{f.addRule(h,e,this.rule_idx);f.addRule(g,i,this.rule_idx+1)}},clear_idx:function(){var e=Foundation.stylesheet;if(this.rule_idx){e.deleteRule(this.rule_idx);e.deleteRule(this.rule_idx);delete this.rule_idx}},small:function(){return matchMedia(Foundation.media_queries.small).matches&&!matchMedia(Foundation.media_queries.medium).matches},off:function(){this.S(this.scope).off(".fndtn.dropdown");this.S("html, body").off(".fndtn.dropdown");this.S(b).off(".fndtn.dropdown");this.S("[data-dropdown-content]").off(".fndtn.dropdown")},reflow:function(){}}}(jQuery,window,window.document));
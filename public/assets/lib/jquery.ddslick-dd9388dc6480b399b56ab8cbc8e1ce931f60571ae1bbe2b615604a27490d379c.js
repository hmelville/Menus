!function(e){function d(e,d){var t=e.data("ddslick"),n=e.find(".dd-selected"),l=n.siblings(".dd-selected-value"),a=(e.find(".dd-options"),n.siblings(".dd-pointer"),e.find(".dd-option").eq(d)),c=a.closest("li"),o=t.settings,r=t.settings.data[d];e.find(".dd-option").removeClass("dd-option-selected"),a.addClass("dd-option-selected"),t.selectedIndex=d,t.selectedItem=c,t.selectedData=r,o.showSelectedHTML?n.html((r.imageSrc?'<img class="dd-selected-image'+("right"==o.imagePosition?" dd-image-right":"")+'" src="'+r.imageSrc+'" />':"")+(r.text?'<label class="dd-selected-text">'+r.text+"</label>":"")+(r.description?'<small class="dd-selected-description dd-desc'+(o.truncateDescription?" dd-selected-description-truncated":"")+'" >'+r.description+"</small>":"")):n.html(r.text),l.val(r.value),n.removeClass("this-year"),n.removeClass("next-year"),n.addClass(r.optionClass),t.original.val(r.value),e.data("ddslick",t),i(e),s(e),"function"==typeof o.onSelected&&o.onSelected.call(this,t)}function t(d){var t=d.find(".dd-select"),i=t.siblings(".dd-options"),s=t.find(".dd-pointer"),l=i.is(":visible");e(".dd-click-off-close").not(i).slideUp(50),e(".dd-pointer").removeClass("dd-pointer-up"),l?(i.slideUp("fast"),s.removeClass("dd-pointer-up")):(i.slideDown("fast"),s.addClass("dd-pointer-up")),n(d)}function i(e){e.find(".dd-options").slideUp(50),e.find(".dd-pointer").removeClass("dd-pointer-up").removeClass("dd-pointer-up")}function s(e){var d=e.find(".dd-select").css("height"),t=e.find(".dd-selected-description"),i=e.find(".dd-selected-image");t.length<=0&&i.length>0&&e.find(".dd-selected-text").css("lineHeight",d)}function n(d){d.find(".dd-option").each(function(){var t=e(this),i=t.css("height"),s=t.find(".dd-option-description"),n=d.find(".dd-option-image");s.length<=0&&n.length>0&&t.find(".dd-option-text").css("lineHeight",i)})}e.fn.ddslick=function(d){return l[d]?l[d].apply(this,Array.prototype.slice.call(arguments,1)):"object"!=typeof d&&d?void e.error("Method "+d+" does not exists."):l.init.apply(this,arguments)};var l={},a={data:[],keepJSONItemsOnTop:!1,width:260,height:null,background:"#eee",selectText:"",defaultSelectedIndex:null,truncateDescription:!0,imagePosition:"left",showSelectedHTML:!0,clickOffToClose:!0,onSelected:function(){}},c='<div class="dd-select"><input class="dd-selected-value" type="hidden" /><a class="dd-selected"></a><span class="dd-pointer dd-pointer-down"></span></div>',o='<ul class="dd-options"></ul>';l.init=function(i){var i=e.extend({},a,i);return this.each(function(){var s=e(this),n=s.data("ddslick");if(!n){var l=[];i.data;s.find("option").each(function(){var d=e(this),t=d.data();l.push({text:e.trim(d.text()),value:d.val(),selected:d.is(":selected"),description:t.description,optionClass:d.attr("class"),imageSrc:t.imagesrc})}),i.keepJSONItemsOnTop?e.merge(i.data,l):i.data=e.merge(l,i.data);var a=s,r=e('<div id="'+s.attr("id")+'_dd"></div>');s.parent().append(r),s.css("display","none"),s=r,s.addClass("dd-container").append(c).append(o);var l=s.find(".dd-select"),p=s.find(".dd-options");l.css({background:i.background}),null!=i.height&&p.css({height:i.height,overflow:"auto"}),e.each(i.data,function(e,d){d.selected&&(i.defaultSelectedIndex=e),p.append('<li><a class="dd-option '+d.optionClass+'">'+(d.value?' <input class="dd-option-value" type="hidden" value="'+d.value+'" />':"")+(d.imageSrc?' <img class="dd-option-image'+("right"==i.imagePosition?" dd-image-right":"")+'" src="'+d.imageSrc+'" />':"")+(d.text?' <label class="dd-option-text">'+d.text+"</label>":"")+(d.description?' <small class="dd-option-description dd-desc">'+d.description+"</small>":"")+"</a></li>")});var f={settings:i,original:a,selectedIndex:-1,selectedItem:null,selectedData:null};if(s.data("ddslick",f),i.selectText.length>0&&null==i.defaultSelectedIndex)s.find(".dd-selected").html(i.selectText);else{var u=null!=i.defaultSelectedIndex&&i.defaultSelectedIndex>=0&&i.defaultSelectedIndex<i.data.length?i.defaultSelectedIndex:0;d(s,u)}s.find(".dd-select").on("click.ddslick",function(){t(s)}),s.find(".dd-option").on("click.ddslick",function(){d(s,e(this).closest("li").index())}),i.clickOffToClose&&(p.addClass("dd-click-off-close"),s.on("click.ddslick",function(e){e.stopPropagation()}),e("body").on("click",function(){e(".dd-click-off-close").slideUp(50).siblings(".dd-select").find(".dd-pointer").removeClass("dd-pointer-up")}))}})},l.select=function(t){return this.each(function(){t.index&&d(e(this),t.index)})},l.open=function(){return this.each(function(){var d=e(this),i=d.data("ddslick");i&&t(d)})},l.close=function(){return this.each(function(){var d=e(this),t=d.data("ddslick");t&&i(d)})},l.destroy=function(){return this.each(function(){var d=e(this),t=d.data("ddslick");if(t){var i=t.original;d.removeData("ddslick").unbind(".ddslick").replaceWith(i)}})}}(jQuery);
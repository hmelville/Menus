tinymce.PluginManager.add("anchor",function(a){var b=function(a){return!a.attr("href")&&(a.attr("id")||a.attr("name"))&&!a.firstChild},c=function(a){return function(c){for(var d=0;d<c.length;d++)b(c[d])&&c[d].attr("contenteditable",a)}},d=function(){var b=a.selection.getNode(),c="",d="A"==b.tagName&&""===a.dom.getAttrib(b,"href");d&&(c=b.name||b.id||""),a.windowManager.open({title:"Anchor",body:{type:"textbox",name:"name",size:40,label:"Name",value:c},onsubmit:function(c){var e=c.data.name;d?b.id=e:(a.selection.collapse(!0),a.execCommand("mceInsertContent",!1,a.dom.createHTML("a",{id:e})))}})};tinymce.Env.ceFalse&&a.on("PreInit",function(){a.parser.addNodeFilter("a",c("false")),a.serializer.addNodeFilter("a",c(null))}),a.addCommand("mceAnchor",d),a.addButton("anchor",{icon:"anchor",tooltip:"Anchor",onclick:d,stateSelector:"a:not([href])"}),a.addMenuItem("anchor",{icon:"anchor",text:"Anchor",context:"insert",onclick:d})});
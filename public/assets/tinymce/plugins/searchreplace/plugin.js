!function(){function a(a){return a&&1==a.nodeType&&"false"===a.contentEditable}function b(b,c,d,e,f){function g(a,b){if(b=b||0,!a[0])throw"findAndReplaceDOMText cannot handle zero-length matches";var c=a.index;if(b>0){var d=a[b];if(!d)throw"Invalid capture group";c+=a[0].indexOf(d),a[0]=d}return[c,c+a[0].length,[a[0]]]}function h(b){var c;if(3===b.nodeType)return b.data;if(o[b.nodeName]&&!n[b.nodeName])return"";if(c="",a(b))return"\n";if((n[b.nodeName]||p[b.nodeName])&&(c+="\n"),b=b.firstChild)do c+=h(b);while(b=b.nextSibling);return c}function i(b,c,d){var e,f,g,h,i=[],j=0,k=b,l=c.shift(),m=0;a:for(;;){if((n[k.nodeName]||p[k.nodeName]||a(k))&&j++,3===k.nodeType&&(!f&&k.length+j>=l[1]?(f=k,h=l[1]-j):e&&i.push(k),!e&&k.length+j>l[0]&&(e=k,g=l[0]-j),j+=k.length),e&&f){if(k=d({startNode:e,startNodeIndex:g,endNode:f,endNodeIndex:h,innerNodes:i,match:l[2],matchIndex:m}),j-=f.length-h,e=null,f=null,i=[],l=c.shift(),m++,!l)break}else if(o[k.nodeName]&&!n[k.nodeName]||!k.firstChild){if(k.nextSibling){k=k.nextSibling;continue}}else if(!a(k)){k=k.firstChild;continue}for(;;){if(k.nextSibling){k=k.nextSibling;break}if(k.parentNode===b)break a;k=k.parentNode}}}function j(a){var b;if("function"!=typeof a){var c=a.nodeType?a:m.createElement(a);b=function(a,b){var d=c.cloneNode(!1);return d.setAttribute("data-mce-index",b),a&&d.appendChild(m.createTextNode(a)),d}}else b=a;return function(a){var c,d,e,f=a.startNode,g=a.endNode,h=a.matchIndex;if(f===g){var i=f;e=i.parentNode,a.startNodeIndex>0&&(c=m.createTextNode(i.data.substring(0,a.startNodeIndex)),e.insertBefore(c,i));var j=b(a.match[0],h);return e.insertBefore(j,i),a.endNodeIndex<i.length&&(d=m.createTextNode(i.data.substring(a.endNodeIndex)),e.insertBefore(d,i)),i.parentNode.removeChild(i),j}c=m.createTextNode(f.data.substring(0,a.startNodeIndex)),d=m.createTextNode(g.data.substring(a.endNodeIndex));for(var k=b(f.data.substring(a.startNodeIndex),h),l=[],n=0,o=a.innerNodes.length;n<o;++n){var p=a.innerNodes[n],q=b(p.data,h);p.parentNode.replaceChild(q,p),l.push(q)}var r=b(g.data.substring(0,a.endNodeIndex),h);return e=f.parentNode,e.insertBefore(c,f),e.insertBefore(k,f),e.removeChild(f),e=g.parentNode,e.insertBefore(r,g),e.insertBefore(d,g),e.removeChild(g),r}}var k,l,m,n,o,p,q=[],r=0;if(m=c.ownerDocument,n=f.getBlockElements(),o=f.getWhiteSpaceElements(),p=f.getShortEndedElements(),l=h(c)){if(b.global)for(;k=b.exec(l);)q.push(g(k,e));else k=l.match(b),q.push(g(k,e));return q.length&&(r=q.length,i(c,q,j(d))),r}}function c(a){function c(){function b(){f.statusbar.find("#next").disabled(!g(l+1).length),f.statusbar.find("#prev").disabled(!g(l-1).length)}function c(){a.windowManager.alert("Could not find the specified string.",function(){f.find("#find")[0].focus()})}var d,e={};d=tinymce.trim(a.selection.getContent({format:"text"}));var f=a.windowManager.open({layout:"flex",pack:"center",align:"center",onClose:function(){a.focus(),k.done()},onSubmit:function(a){var d,h,i,j;return a.preventDefault(),h=f.find("#case").checked(),j=f.find("#words").checked(),i=f.find("#find").value(),i.length?e.text==i&&e.caseState==h&&e.wholeWord==j?0===g(l+1).length?void c():(k.next(),void b()):(d=k.find(i,h,j),d||c(),f.statusbar.items().slice(1).disabled(0===d),b(),void(e={text:i,caseState:h,wholeWord:j})):(k.done(!1),void f.statusbar.items().slice(1).disabled(!0))},buttons:[{text:"Find",subtype:"primary",onclick:function(){f.submit()}},{text:"Replace",disabled:!0,onclick:function(){k.replace(f.find("#replace").value())||(f.statusbar.items().slice(1).disabled(!0),l=-1,e={})}},{text:"Replace all",disabled:!0,onclick:function(){k.replace(f.find("#replace").value(),!0,!0),f.statusbar.items().slice(1).disabled(!0),e={}}},{type:"spacer",flex:1},{text:"Prev",name:"prev",disabled:!0,onclick:function(){k.prev(),b()}},{text:"Next",name:"next",disabled:!0,onclick:function(){k.next(),b()}}],title:"Find and replace",items:{type:"form",padding:20,labelGap:30,spacing:10,items:[{type:"textbox",name:"find",size:40,label:"Find",value:d},{type:"textbox",name:"replace",size:40,label:"Replace with"},{type:"checkbox",name:"case",text:"Match case",label:" "},{type:"checkbox",name:"words",text:"Whole words",label:" "}]}})}function d(a){var b=a.getAttribute("data-mce-index");return"number"==typeof b?""+b:b}function e(c){var d,e;return e=a.dom.create("span",{"data-mce-bogus":1}),e.className="mce-match-marker",d=a.getBody(),k.done(!1),b(c,d,e,!1,a.schema)}function f(a){var b=a.parentNode;a.firstChild&&b.insertBefore(a.firstChild,a),a.parentNode.removeChild(a)}function g(b){var c,e=[];if(c=tinymce.toArray(a.getBody().getElementsByTagName("span")),c.length)for(var f=0;f<c.length;f++){var g=d(c[f]);null!==g&&g.length&&g===b.toString()&&e.push(c[f])}return e}function h(b){var c=l,d=a.dom;b=b!==!1,b?c++:c--,d.removeClass(g(l),"mce-match-marker-selected");var e=g(c);return e.length?(d.addClass(g(c),"mce-match-marker-selected"),a.selection.scrollIntoView(e[0]),c):-1}function i(b){var c=a.dom,d=b.parentNode;c.remove(b),c.isEmpty(d)&&c.remove(d)}function j(a){var b=d(a);return null!==b&&b.length>0}var k=this,l=-1;k.init=function(a){a.addMenuItem("searchreplace",{text:"Find and replace",shortcut:"Meta+F",onclick:c,separator:"before",context:"edit"}),a.addButton("searchreplace",{tooltip:"Find and replace",shortcut:"Meta+F",onclick:c}),a.addCommand("SearchReplace",c),a.shortcuts.add("Meta+F","",c)},k.find=function(a,b,c){a=a.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g,"\\$&"),a=c?"\\b"+a+"\\b":a;var d=e(new RegExp(a,b?"g":"gi"));return d&&(l=-1,l=h(!0)),d},k.next=function(){var a=h(!0);a!==-1&&(l=a)},k.prev=function(){var a=h(!1);a!==-1&&(l=a)},k.replace=function(b,c,e){var h,m,n,o,p,q,r=l;for(c=c!==!1,n=a.getBody(),m=tinymce.grep(tinymce.toArray(n.getElementsByTagName("span")),j),h=0;h<m.length;h++){var s=d(m[h]);if(o=p=parseInt(s,10),e||o===l){for(b.length?(m[h].firstChild.nodeValue=b,f(m[h])):i(m[h]);m[++h];){if(o=parseInt(d(m[h]),10),o!==p){h--;break}i(m[h])}c&&r--}else p>l&&m[h].setAttribute("data-mce-index",p-1)}return a.undoManager.add(),l=r,c?(q=g(r+1).length>0,k.next()):(q=g(r-1).length>0,k.prev()),!e&&q},k.done=function(b){var c,e,g,h;for(e=tinymce.toArray(a.getBody().getElementsByTagName("span")),c=0;c<e.length;c++){var i=d(e[c]);null!==i&&i.length&&(i===l.toString()&&(g||(g=e[c].firstChild),h=e[c].firstChild),f(e[c]))}if(g&&h){var j=a.dom.createRng();return j.setStart(g,0),j.setEnd(h,h.data.length),b!==!1&&a.selection.setRng(j),j}}}tinymce.PluginManager.add("searchreplace",c)}();
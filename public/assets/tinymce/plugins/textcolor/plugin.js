!function(){"use strict";var t=tinymce.util.Tools.resolve("tinymce.PluginManager"),e=function(t,e){var o;return t.dom.getParents(t.selection.getStart(),function(t){var r;(r=t.style["forecolor"===e?"color":"background-color"])&&(o=o||r)}),o},o=function(t){var e,o=[];for(e=0;e<t.length;e+=2)o.push({text:t[e+1],color:"#"+t[e]});return o},r=function(t,e,o){t.undoManager.transact(function(){t.focus(),t.formatter.apply(e,{value:o}),t.nodeChanged()})},n=function(t,e){t.undoManager.transact(function(){t.focus(),t.formatter.remove(e,{value:null},null,!0),t.nodeChanged()})},a=function(t){t.addCommand("mceApplyTextcolor",function(e,o){r(t,e,o)}),t.addCommand("mceRemoveTextcolor",function(e){n(t,e)})},l=tinymce.util.Tools.resolve("tinymce.dom.DOMUtils"),c=tinymce.util.Tools.resolve("tinymce.util.Tools"),i=["000000","Black","993300","Burnt orange","333300","Dark olive","003300","Dark green","003366","Dark azure","000080","Navy Blue","333399","Indigo","333333","Very dark gray","800000","Maroon","FF6600","Orange","808000","Olive","008000","Green","008080","Teal","0000FF","Blue","666699","Grayish blue","808080","Gray","FF0000","Red","FF9900","Amber","99CC00","Yellow green","339966","Sea green","33CCCC","Turquoise","3366FF","Royal blue","800080","Purple","999999","Medium gray","FF00FF","Magenta","FFCC00","Gold","FFFF00","Yellow","00FF00","Lime","00FFFF","Aqua","00CCFF","Sky blue","993366","Red violet","FFFFFF","White","FF99CC","Pink","FFCC99","Peach","FFFF99","Light yellow","CCFFCC","Pale green","CCFFFF","Pale cyan","99CCFF","Light sky blue","CC99FF","Plum"],u=function(t){return t.getParam("textcolor_map",i)},m=function(t){return t.getParam("textcolor_rows",5)},s=function(t){return t.getParam("textcolor_cols",8)},d=function(t){return t.getParam("color_picker_callback",null)},f=function(t){return t.getParam("forecolor_map",u(t))},g=function(t){return t.getParam("backcolor_map",u(t))},F=function(t){return t.getParam("forecolor_rows",m(t))},b=function(t){return t.getParam("backcolor_rows",m(t))},p=function(t){return t.getParam("forecolor_cols",s(t))},C=function(t){return t.getParam("backcolor_cols",s(t))},y=d,v=function(t){return"function"==typeof d(t)},h=tinymce.util.Tools.resolve("tinymce.util.I18n"),P=function(t,e,r,n){var a,c,i,u,m,s,d,f=0,g=l.DOM.uniqueId("mcearia"),F=function(t,e){var o="transparent"===t;return'<td class="mce-grid-cell'+(o?" mce-colorbtn-trans":"")+'"><div id="'+g+"-"+f+++'" data-mce-color="'+(t||"")+'" role="option" tabIndex="-1" style="'+(t?"background-color: "+t:"")+'" title="'+h.translate(e)+'">'+(o?"&#215;":"")+"</div></td>"};for((a=o(r)).push({text:h.translate("No color"),color:"transparent"}),i='<table class="mce-grid mce-grid-border mce-colorbutton-grid" role="list" cellspacing="0"><tbody>',u=a.length-1,s=0;s<e;s++){for(i+="<tr>",m=0;m<t;m++)i+=u<(d=s*t+m)?"<td></td>":F((c=a[d]).color,c.text);i+="</tr>"}if(n){for(i+='<tr><td colspan="'+t+'" class="mce-custom-color-btn"><div id="'+g+'-c" class="mce-widget mce-btn mce-btn-small mce-btn-flat" role="button" tabindex="-1" aria-labelledby="'+g+'-c" style="width: 100%"><button type="button" role="presentation" tabindex="-1">'+h.translate("Custom...")+"</button></div></td></tr>",i+="<tr>",m=0;m<t;m++)i+=F("","Custom color");i+="</tr>"}return i+"</tbody></table>"},k=function(t,e){t.style.background=e,t.setAttribute("data-mce-color",e)},x=function(t){return function(e){var o=e.control;o._color?t.execCommand("mceApplyTextcolor",o.settings.format,o._color):t.execCommand("mceRemoveTextcolor",o.settings.format)}},T=function(t,o){return function(r){var n,a=this.parent(),i=e(t,a.settings.format),u=function(e){t.execCommand("mceApplyTextcolor",a.settings.format,e),a.hidePanel(),a.color(e)};l.DOM.getParent(r.target,".mce-custom-color-btn")&&(a.hidePanel(),y(t).call(t,function(t){var e,r,n,l=a.panel.getEl().getElementsByTagName("table")[0];for(e=c.map(l.rows[l.rows.length-1].childNodes,function(t){return t.firstChild}),n=0;n<e.length&&(r=e[n]).getAttribute("data-mce-color");n++);if(n===o)for(n=0;n<o-1;n++)k(e[n],e[n+1].getAttribute("data-mce-color"));k(r,t),u(t)},i)),(n=r.target.getAttribute("data-mce-color"))?(this.lastId&&l.DOM.get(this.lastId).setAttribute("aria-selected","false"),r.target.setAttribute("aria-selected",!0),this.lastId=r.target.id,"transparent"===n?(t.execCommand("mceRemoveTextcolor",a.settings.format),a.hidePanel(),a.resetColor()):u(n)):null!==n&&a.hidePanel()}},_=function(t,e){return function(){var o=e?p(t):C(t),r=e?F(t):b(t),n=e?f(t):g(t),a=v(t);return P(o,r,n,a)}},A=function(t){t.addButton("forecolor",{type:"colorbutton",tooltip:"Text color",format:"forecolor",panel:{role:"application",ariaRemember:!0,html:_(t,!0),onclick:T(t,p(t))},onclick:x(t)}),t.addButton("backcolor",{type:"colorbutton",tooltip:"Background color",format:"hilitecolor",panel:{role:"application",ariaRemember:!0,html:_(t,!1),onclick:T(t,C(t))},onclick:x(t)})};t.add("textcolor",function(t){a(t),A(t)})}();
(function(){$(function(){var t,e,n;return n=$("@project-discussion"),n.on("click",function(o){var r;return o.preventDefault(),n.each(function(){return t($(this))}),r=$(this),e(r)}),e=function(e){var n,o;return e.removeClass("rolled"),n=e.find("@project-discussion-comments-counter"),o=e.find("@project-discussion-comments-hide"),n.hide(),o.show(),$("#project-tab-pane").scrollTop(e.position().top),o.on("click",function(n){return n.preventDefault(),n.stopPropagation(),t(e)})},t=function(t){var e,n;return e=t.find("@project-discussion-comments-counter"),n=t.find("@project-discussion-comments-hide"),n.hide(),e.show(),t.addClass("rolled")}})}).call(this);
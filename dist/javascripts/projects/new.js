(function(){window.NewProject||(window.NewProject={}),function(){return $(document).ready(function(){var t,e,n,i,s,o,r,a,c,l,u,d,h,p,f,m,g,v,y;return y=$("@step-switcher"),v=$("@step-informer"),g=$("@step-indicator"),m=$("@form-step"),e=$("@step-back-btn"),l=$("@team-list"),u=$("@projects-form-select2btn"),y.on("click",function(t){var e;return t.preventDefault(),e=$(this).data("step"),p(e)}),g.on("click",function(t){var e;return t.preventDefault(),e=$(this).data("step"),p(e)}),e.on("click",function(t){var e;return t.preventDefault(),e=$(this).data("target"),p(e)}),u.on("click",function(t){return t.preventDefault(),$("#select2-drop-mask").show(),$("#select2-drop").show()}),p=function(t){return null!=t?(h(t),f(t),d(t)):void 0},f=function(t){return v.find("@step-indicator").removeClass("active"),v.find('@step-indicator[data-step="'+t+'"]').addClass("active")},h=function(t){return m.hide(),m.filter('[data-step="'+t+'"]').show()},d=function(t){return e.hide(),e.filter('[data-step="'+t+'"]').show()},i=$("@projects-form-goal-editor"),s=i.find("textarea"),t=$("@projects-form-add-project-goal"),o=$("@projects-form-goals-list"),n=i.find("@save-button, @cancel-button, @delete-button"),t.on("click",function(t){return t.preventDefault(),i.show()}),n.on("click",function(t){return t.preventDefault(),i.hide(),s.val("")}),o.find("li").on("click",function(){var t;return t=$(this).text(),i.show(),s.val(t)}),a=$("@add-another-community"),c=$("@project-team-select-community"),a.on("change",function(){var t,e,n,i,s,o,r;for(i=$(this).val(),t=c.last(),r=[],s=0,o=i.length;o>s;s++)n=i[s],e="<option>"+n+"</option>",r.push($(e).insertAfter(t));return r}),r=$("@project-team-member-checkbox-admin"),r.on("click",function(t){return t.preventDefault(),$(this).toggleClass("active")})})}(window.NewProject||(window.NewProject={})),function(){return $(document).ready(function(){var t;return t=$("@select2-multiple"),t.select2()})}(window.NewProject||(window.NewProject={}))}).call(this);
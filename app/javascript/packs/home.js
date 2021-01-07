const VLazyImagePlugin = window['VLazyImage'].VLazyImagePlugin;
Vue.use(VLazyImagePlugin);

Vue.component('paginate', VuejsPaginate)

new Vue({
   el: '#tabelog_ranking',
   data: data,
   methods: {
    clickCallback: function (pageNum) {
       this.currentPage = Number(pageNum);
    }
   },
   computed: {
     getItems: function() {
      let current = this.currentPage * this.parPage;
      let start = current - this.parPage;
      return this.tabelogitems.slice(start, current);
     },
     getPageCount: function() {
      return Math.ceil(this.tabelogitems.length / this.parPage);
    },
   }
 })

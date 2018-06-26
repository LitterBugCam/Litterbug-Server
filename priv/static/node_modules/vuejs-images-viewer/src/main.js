/**
 * Created by fm on 2017/10/18.
 */
import Vue from 'vue'
import App from './components/app.vue'


new Vue({
    el: '#app',
    data: {
        images:[]
    },
    methods:{
        rotate_callback() {
            console.log('finished');
        }
    },
    components: { 'images-viewer':App }
})
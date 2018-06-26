/**
 * Created by fm on 2017/10/19.
 */
import ImagesViewer from './components/App.vue';

module.exports = {
    install: function (Vue, options) {
        Vue.component('images-viewer', ImagesViewer);
    }
};
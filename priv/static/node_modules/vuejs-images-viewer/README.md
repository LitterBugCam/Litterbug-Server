# vuejs-images-viewer
[![Build Status](https://travis-ci.org/conventional-changelog/standard-version.svg?branch=master)](https://travis-ci.org/conventional-changelog/standard-version)
[![NPM version](https://img.shields.io/badge/npm-v1.0.7-brightgreen.svg)](https://www.npmjs.com/package/vuejs-images-viewer)

## Installation
```js
npm install vuejs-images-viewer --save
```

### Browser
Include the script file, then install the component with `Vue.use(ImagesViewer);` e.g.:

```html
<!--Plugin!-->
<script type="text/javascript" src="node_modules/vuejs-images-viewer/dist/app.js"></script>
<!--Template!-->
<script type="text/javascript" src="node_modules/vuejs-images-viewer/dist/app.min.js"></script>
<script type="text/javascript">
  Vue.use(ImagesViewer);
</script>
```

### Module

```js
import imagesViewer from 'vuejs-images-viewer';
```

```js
const app = new Vue({
    el: '#app',
    components: {
        'images-viewer': imagesViewer
    }
});
```

## Usage

Once installed, it can be used in a template as simply as:

```html
<images-viewer></images-viewer>
```
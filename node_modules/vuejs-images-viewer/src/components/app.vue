<template lang="html">
    <div class="fm-images-viewer" v-bind:style="{'heigth':height}">
        <canvas id="canvas"></canvas>
        <div>
            <button @click="clockwise" class="btn btn-default"><i class="material-icons">rotate_right</i></button>
            <button @click="counterclockwise" class="btn btn-default"><i class="material-icons">rotate_left</i></button>
            <button @click="nextImage" class="btn btn-default">Image</button>
        </div>

    </div>
</template>

<script>

    export default {
        props:{
            height: {
                type: String,
                required:false,
                default: '600px'
            },
            max_width: {
                type: [String, Number],
                required: false,
                default: '100%'
            },
            images: {
                type: Array,
                required: false,
                default: function () {
                    return [
                        {'url':'https://www.ikepo.com.tw/uimages/U4efce419d9868e162a4b1efaea21b850/6854315974753.jpeg'},
                        {'url':'/dist/6854315974753.jpeg'},
                        {'url':'http://www.realty.com.tw/image/data/tw_s1/A3912_5.jpg'},
                    ];
                }
            },
            rotate_callback: {
                type: Function,
                required: false,
                default: function() {
                    return true;
                }
            }
        },
        mounted() {
            console.log('Component mounted.');

            var _this = this;
            this.elm.canvas = document.getElementById("canvas");
            this.context = canvas.getContext("2d");
            this.elm.image = document.createElement("img");



            this.$nextTick(function() {
                setTimeout(function() {
                    _this.imageIndex = 0;

                    _this.initialize();

                },300)

            })


        },
        data() {
            return {
                elm: {
                    canvas:{},
                    image:{},
                },
                viewer: {
                    background: '#eee',
                    angle:0
                },
                context:{},
                imageIndex:0,
                image: {
                    direct: true
                }

            }
        },
        methods: {
            initialize() {

				window.addEventListener('resize', this.resizeCanvas, false);
				this.loadImage();
			},
			resizeCanvas() {
				//this.elm.canvas.width = this.elm.canvas.parentElement.clientWidth;
				//this.canvas.height = this.canvas.parentElement.clientHeight;
                this.render();
			},
			nextImage() {
			    this.imageIndex = this.imageIndex + 1;
			    var maxIndex = this.images.length - 1;
			    if (this.imageIndex > maxIndex) {
			        this.imageIndex = maxIndex;
			        return ;
			    }

			    this.context.clearRect(0,0,this.elm.canvas.width, this.elm.canvas.height);

			    this.loadImage();
			},

			loadImage() {
			    var _this = this;

			    this.elm.image.onload=function(){
                    _this.render();
                }
                this.elm.image.src = this.images[this.imageIndex].url;
			},
			resizeImage() {

                  var maxWidth = this.elm.canvas.parentElement.clientWidth;
                  var maxHeight = this.elm.canvas.parentElement.clientHeight;
                  var maxSize = {w: maxWidth, h: maxHeight};

                  var newSize = {w:this.elm.image.width,h:this.elm.image.height}


                  var tmpMaxSize = maxSize;

                  if (!this.image.direct) {
                    tmpMaxSize = {w: maxHeight, h: maxWidth}
                  }

                  if (newSize.w > tmpMaxSize.w) {
                    newSize.h = newSize.h * tmpMaxSize.w / newSize.w
                    newSize.w = tmpMaxSize.w
                  }

                  if(newSize.h > tmpMaxSize.h) {
                    newSize.w = newSize.w * tmpMaxSize.h / newSize.h
                    newSize.h = tmpMaxSize.h
                  }

                    this.elm.canvas.width = maxSize.w;
                    this.elm.canvas.height = maxSize.h;

                    console.log('MAX',maxSize);
                    console.log('NEW',newSize);

                    return newSize;

			},

            render() {
                var size = this.resizeImage();

                var imageSize = {w:size.w,h:size.h};
                var canvasCenter = {x:canvas.width * 0.5, y: canvas.height * 0.5};
                var imageCenter =  {x:imageSize.w * 0.5, y: imageSize.h * 0.5};

                var rotateImgCenter = {x:-imageCenter.x ,y: -imageCenter.y}

                this.context.translate(canvasCenter.x, canvasCenter.y );
                this.context.rotate( this.viewer.angle * Math.PI / 180);

                this.context.drawImage(this.elm.image, 0, 0, this.elm.image.width, this.elm.image.height, rotateImgCenter.x, rotateImgCenter.y ,imageSize.w,imageSize.h);
            },
            imageDirect() {
                this.image.direct = !this.image.direct
                return this.image.direct;
            },
            clockwise() {
                this.viewer.angle += 90;
                this.imageDirect();
                this.render();

                this.rotate_callback();
            },
            counterclockwise() {
                this.viewer.angle -= 90;
                this.imageDirect();
                this.render();

                this.rotate_callback();
            },

        },

    }

</script>

<style lang="css">
    .fm-images-viewer {
        text-align: center;
        width: 100%;
        height:600px;
        /*border: 5px solid #000;*/
    }
</style>
; Copyright (c) 2010, Jeffrey Aylesworth <jeffrey@aylesworth.ca>
; 
; Permission to use, copy, modify, and/or distribute this software for any
; purpose with or without fee is hereby granted, provided that the above
; copyright notice and this permission notice appear in all copies.
; 
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

(define (script-fu-create-camo image drawable colA colB)
    (define wdth (car (gimp-image-width image)))
    (define height (car (gimp-image-height image)))
    (define type (car (gimp-drawable-type-with-alpha drawable)))
    (define (do-camo col)
        (let
        ((layer (car (gimp-layer-new image wdth height type "a" 100 0))))
            (gimp-image-add-layer image layer -1)
            (plug-in-solid-noise
                1
                image
                layer
                0
                0
                (rand)
                1
                4
                4)
            (gimp-posterize layer 2)
            (gimp-invert layer)
            (plug-in-colortoalpha 1 image layer '(0 0 0))
            (plug-in-colorify 1 image layer col)
            layer))


    (gimp-image-undo-group-start image)
    (let
        ((layerA (do-camo colA))
        (layerB (do-camo colB)))

        (let ((new (car (gimp-image-merge-down image layerB  2))))
            (gimp-drawable-update new 0 0 wdth height)
        )
    )
    (gimp-image-undo-group-end image)
)

(script-fu-register
    "script-fu-create-camo"
    "Camouflage"
    "Creates a camouflage pattern on an image"
    "Jeffrey Aylesworth <jeffrey@aylesworth"
    "Copyright (c) 2009 Jeffrey Aylesworth"
    "2010/01/01"
    ""

    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0
    SF-COLOR "Colour 1" '(50 0 0)
    SF-COLOR "Colour 2" '(0 50 0))

(script-fu-menu-register "script-fu-create-camo" _"<Image>/Filters/Render")

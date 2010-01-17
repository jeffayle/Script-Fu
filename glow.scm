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

(define (script-fu-make-glow image drawable size)
    (define width (car (gimp-image-width image)))
    (define height (car (gimp-image-height image)))
    (define type (car (gimp-drawable-type-with-alpha drawable)))
    (define new-layer (car (gimp-layer-new image width height type "a" 100 0)))
    ;add the new layer to the image
    (gimp-image-add-layer image new-layer -1)
    
    (gimp-selection-layer-alpha drawable)
    (gimp-selection-grow image size)
    (gimp-selection-feather image size)
    (gimp-edit-bucket-fill-full
        new-layer
        FG-BUCKET-FILL
        NORMAL-MODE
        100
        0
        FALSE
        FALSE
        SELECT-CRITERION-COMPOSITE
        0
        0
    )
    (gimp-selection-clear image)
)

(script-fu-register
    "script-fu-make-glow"
    "Add Glow"
    "Adds a glow to a layer"
    "Jeffrey Aylesworth <jeffrey@aylesworth>"
    "Copyright (c) 2010 Jeffrey Aylesworth"
    "2010/01/16"
    ""

    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0
    SF-VALUE "Size" "3"
    )

(script-fu-menu-register "script-fu-make-glow" "<Image>/Filters/Decor")

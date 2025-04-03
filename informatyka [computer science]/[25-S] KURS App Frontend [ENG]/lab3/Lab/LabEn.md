# Task: Styling a Modern Blog (10 points)

Your task is to style a blog page according to the guidelines below. The styling should be implemented using only CSS. You may edit the HTML code only in the places indicated by comments. The final appearance of the page should match the [image](sol.png) ([full resolution](sol_fullres.png)).

Download the [entire folder](./) containing this file. You will place your solution in the [style.css](style.css) file.

Try to use classes wherever possible.

## Materials

In the solutions, you will need to use techniques such as `float`, `flex`, `grid`, positioning (`sticky`, `absolute`, `relative`), as well as an understanding of [Stacking Context](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_positioned_layout/Stacking_context) and [Block Formatting Context](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_display/Block_formatting_context).

The following properties were used in the reference solution:

`box-sizing`, `margin`, `padding`, `font-size`, `text-align`, `background-color`, `box-shadow`, `display`, `justify-content`, `position`, `top`, `list-style`, `text-decoration`, `color`, `width`, `height`, `align-items`, `clear`, `font-size`, `border`, `border-radius`, `gap`, `object-fit`, `color`, `border-radius`, `z-index`, `position`, `background-color`, `text-align`, `color`

And selectors not based on classes:

`*`, `body`, `h1`, `h2`, `h3`, `:nth-of-type()`

## Introduction

Set the `box-sizing` of all elements to `border-box` and remove both margin and padding from the `body`. Then set the font sizes:

- `h1` should have a font size of `2.5` times the root font size.
- `h2` should have a font size of `1.8` times the root font size and be centered.
- `h3` should have a font size of `1.5` times the root font size.

Finally, remove the margins from `blog__header` and set `content__main` to have a background color of `#ececf7` and padding of `1rem` from the top and `2rem` from the left and right.

## Header

- The header should have a white background and a shadow: `0` offset on the x-axis, `3px` on the y-axis, `4px` blur-radius, and a color of `rgba(0, 0, 0, 0.1)`.
- The content of the header should be spaced `2rem` from the edges.
- Text should be aligned to the left, and links should be aligned to the right, with spacing in between.
- Links should have no bullet points, margins, or padding, and should be displayed as `flex`.
  - Each link should be black, not underlined, and have a width of `100px`.
  - The link should cover an area of `100px` width and full height: the entire area should be clickable.
  - The link should have a background color of `#f1f1f1` on hover.
  - The text of the link should be centered both horizontally and vertically.
- The header should always stay at the top of the screen, regardless of where we are on the page.

<details>
  <summary>Hint for Element Positioning</summary>

> Use Flexbox. Set the `justify-content` property to position the elements properly.

</details>

<details>
  <summary>Hint for Links</summary>

> Remove `list-style`, `margin`, and `padding` from the list (class `navigation`). Setting height/width on the link does not work because the link is displayed as `inline-block`: set it as `flexbox`, with the appropriate width and full height. This will make centering the text easier. Finally, make sure the link can grow to 100% height: its parents may also need to have the height set properly.

</details>

<details>
  <summary>Hint for the Last Point</summary>

> You need to "stick" the header. To do this, set the appropriate value for `position`, which also requires specifying the `top` (or equivalent) value for it to work.

</details>

## "Blog" Section

In this section, set the images to float with text: the first and last article images should float on the right of the text, and the second one on the left. Ensure that the articles do not overlap, meaning the images do not enter other sections. The captions under the images should have a size of `0.8` times the root font size and be centered.

<details>
  <summary>Hint</summary>

> For floating, you might find the `:nth-of-type` pseudo-class useful. Applied to the `article` class, it can select the appropriate (first and last or second) article, from which you can access the image. For preventing the overlap, the `clear` property might be useful.

</details>

At the end of the section, there is a `warning`. It should have a background color of `#f4c5b7`, a border of `#faf9f8` and `3px` thickness, and a border radius of `20px`. The text "Warning!" should be centered, and the image should float to the left of the text.

When setting up the image float, it may have "escaped" outside of the warning's background. This is undesirable, and you should fix the issue without modifying the HTML.

<details>
  <summary>Hint</summary>

> This has a lot to do with [BFC](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_display/Block_formatting_context). The page explains this phenomenon, along with a solution directly related to this issue, and provides examples of the solution.

</details>

## "Gallery" Section

Using `grid`, create a gallery. The elements in the gallery should be spaced `1rem` apart. The gallery should have 3 columns and 2 rows. The images inside the gallery should fully fill the available width and height (regardless of screen size), and to solve potential sizing issues, the `object-fit` property should be set to `cover`.

The positions of the images should be as follows:

- The first image should be in the first column and span 2 rows.
- The second image should be in the first row and the third column.
- The third image should be in the second row, starting at the second column and spanning 2 columns.
- The fourth image should be placed automatically.

## "Posts" Section

The last section is the "posts" section. In this section, apply the following rules:

- Each image should be `300px` wide and `200px` tall. To maintain the proper aspect ratio, the `object-fit` property should be set to `cover`.
- The section (`posts__wrapper`) should have a height of `300px`. The second post should be shifted `250px` from the left relative to the first post.
- Each post consists of **three elements**:
  1. **Image** – should be placed at the bottom (not under image!).
  2. **Caption** – should:
     - Be positioned at the bottom of the image.
     - Have full width.
     - Have a background color of `royalblue` and white, centered text.
  3. **"i" Element** – should:
     - Be `30x30` pixels.
     - Have a background color of `salmon`.
     - Contain white, centered text.
     - Be fully rounded.
- **Behavior of Posts**:
  - Posts should **overlap**.
  - By default, the first post should be on top.
  - When hovering over the second post, it should come on top.
  - **Do not use a `z-index` value greater than `1`**.

<details>
  <summary>Hint</summary>

> You can use `position: absolute` to arrange the elements of the post and `position: relative` to control their mutual positioning.  
> To dynamically change the layering order when hovering, try applying `z-index` in a dynamic way.

</details>

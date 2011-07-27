title: Using Markdown or Textile
--

#### Custom formatting
You can use Markdown in your CMS. Go to HTML editing mode, and simply use
`<div format='markdown'>` on a block you want to Markdown-ify.

    <div format='markdown'>
      ### Hello

      * This is Markdown text.
      * In your site, this will look just like how it should be.
    </div>

#### Textile
To use Textile, just use `format='textile'` instead.

    <div format='textile'>
      h3. Hello again

      * This is Textile text!
      * In your site, this will look just like how it should be.
    </div>


<link href='http://fonts.googleapis.com/css?family=Raleway' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Berkshire+Swash' rel='stylesheet' type='text/css'>
<link rel="stylesheet" class="text/css" href="<? print($rel); ?>main.css">

<!-- PhotoSwipe -->
  <? $psPath = $rel.'photoswipe/' ?>
  <!-- Core CSS file -->
  <link rel="stylesheet" href="<? echo($psPath); ?>photoswipe.css">

  <!-- Skin CSS file (styling of UI - buttons, caption, etc.)
       In the folder of skin CSS file there are also:
       - .png and .svg icons sprite,
       - preloader.gif (for browsers that do not support CSS animations) -->
  <link rel="stylesheet" href="<? echo($psPath); ?>default-skin/default-skin.css">

  <!-- Core JS file -->
  <script src="<? echo($psPath); ?>photoswipe.min.js"></script>

  <!-- UI JS file -->
  <script src="<? echo($psPath); ?>photoswipe-ui-default.min.js"></script>

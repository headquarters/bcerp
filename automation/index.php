<?php 
    require_once 'Image/Puzzle.php';
    
    $options = array(
        'rows' => 2,
        'cols' => 3
    );
    
    $puzzle = new Image_Puzzle($options);
    
    $puzzle->createFromFile('fb/image4.jpg');
    
    $puzzle->saveAll();
?>
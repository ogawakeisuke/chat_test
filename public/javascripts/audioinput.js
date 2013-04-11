console.log("start");
  var video = document.getElementById('myVideo');
  navigator.getMedia = ( navigator.getUserMedia ||
                          navigator.webkitGetUserMedia ||
                          navigator.mozGetUserMedia ||
                          navigator.msGetUserMedia );

  navigator.getMedia({audio:true, video:true}, success, error);

  function success(stream) {
    var context = new webkitAudioContext();
    var source = context.createMediaStreamSource(stream);
    var audioAnalyser = context.createAnalyser();
    var audioAnalyzedData = new Uint8Array(audioAnalyser.frequencyBinCount);

    source.connect(audioAnalyser);
    //source.connect(context.destination);

    data = audioAnalyser.getByteFrequencyData(audioAnalyzedData);
    console.log(audioAnalyzedData[500]);

    // ためし
    $("button").bind("click",function(){
      audioAnalyser.getByteFrequencyData(audioAnalyzedData);
      console.log(audioAnalyzedData);   
      // alert(audioAnalyzedData[500]);
      $(".aaa").text(audioAnalyzedData[500]); 
      start();
    });

    setInterval(function(){
      audioAnalyser.getByteFrequencyData(audioAnalyzedData);
      if (audioAnalyzedData[100] > 120){
        $(".aaa").text("ふいてる");
        console.log("ふいてる");    
      };
      $(".aaa").text("");
    },100);

    // video.src = window.webkitURL.createObjectURL(stream);
    
  }
  
  function error(err) {
    console.log(err);
  }
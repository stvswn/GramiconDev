jQuery(document).ready( function() { 

	$(".chzn-select").chosen({
		allow_single_deselect: true
	});

	/* Activating Best In Place */
	jQuery(".best_in_place").best_in_place();

  // $('.dropdown-toggle').dropdown();
  $('.put-in-folder').click(function() {

  $(this).closest('.message').hide('slow');
    return false;
  });


  function setNumCredits(credits) {
    if (credits!=undefined){
      $('.num-credits.master').data('numcredits',credits);
      $('.num-credits').text(credits);
    }
    var credits_left = $('.num-credits.master').data('numcredits');
    $('span.credits-balance-after-message').text(credits_left);
  }
  setNumCredits();

  function doMessageCreditCost(){  
    if ($('.message-cost').length>0) {
      value = parseInt($('.message-cost').val());
      if (!value)
        value = 0;
      $('span.message-cost').text(value);
      var credits_left = $('.num-credits.master').data('numcredits');
  
      if (credits_left < value) {
        $('span.credits-balance-after-message').text('no');
        $('.send-message-button').attr('disabled','disabled');
        $('.not-enough-credit-section').show();
      }
      else {
        $('span.credits-balance-after-message').text(credits_left - value);
        $('.send-message-button').attr('disabled',false);
        $('.not-enough-credit-section').hide();
      }
    }
  }


  function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(window.location.search);
    if(results == null)
      return "";
    else
      return decodeURIComponent(results[1].replace(/\+/g, " "));
  }

  modal = getParameterByName('mod');
  if (modal.length > 0) {
    if ($('#'+modal)) {
      $('#'+modal).modal('show');
    }
  }

  if ($('.message-cost').length>0) {
    doMessageCreditCost();
    $('.message-cost').keyup(doMessageCreditCost);
  }

  $('.disable-next-button').click(function() {
    if ($(this).is(':checked')) {
      $(this).closest('form').find('.btn-primary').attr('disabled',false);
    }
    else {
      $(this).closest('form').find('.btn-primary').attr('disabled','disabled');
    }
  });

  $('input[rel="tooltip"]').tooltip();
  $('i[rel="tooltip"]').tooltip();
  $('button[rel="tooltip"]').tooltip();
  $('span[rel="tooltip"]').tooltip();

  function doSecondCountdown() {
    $('.seconds-countdown').each(function(idx,el){
      current_val = parseInt($(el).text());
        if (current_val!=0)
          $(el).text(current_val-1);
    });
  }

  if ($('.seconds-countdown').length>0){
    setInterval(doSecondCountdown,1000);
  }


  $('form.get-credit-ajax-form')
    .bind("ajax:success", function(evt, data, status, xhr){
      $(this).find('div.validation-error').empty();
      setNumCredits(data.new_balance);
      doMessageCreditCost();
    })






  $("#users th a, #users .pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  function paramsChanged() {
    $.get($("#users_search").attr("action"), $("#users_search").serialize(), null, "script");
  } 
  $("#users_search input").keyup(function() {
    paramsChanged();
    return false;
  });
  $("#users_search input:checkbox").click(function() {
    paramsChanged();
  });

  sliderMinMax = [18, 99];

  function ageValues(values) {

    console.log(values[0],values[1]);

    if (sliderMinMax[0]==values[0] && sliderMinMax[1]==values[1]) {
      // on the min and max (want to see as much as possible)
      label = "Age: any";
      min = '';
      max = '';
    }
    else {
      label = "Age: "+values[0]+" - "+values[1];
      min = values[0];
      max = values[1];
    }

    $(".slider-label").html(label)
    $(".sminage").val(min);
    $(".smaxage").val(max);
  }

  $( "#slider-range" ).slider({
    range: true,
    min: 18,
    max: 99,
    values: sliderMinMax,
    slide: function(event, ui) {
      ageValues(ui.values);
    },
    stop: paramsChanged
  });
  ageValues([$('.sminage').val(),$('.smaxage').val()]);



});
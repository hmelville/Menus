$(document).ready(function(){
    $('#user_password').pStrength({
      'changeBackground'          : false,
      'onPasswordStrengthChanged' : function(passwordStrength, strengthPercentage) {
        if ($(this).val()) {
            $.fn.pStrength('changeBackground', this, passwordStrength);
            if (passwordStrength < 4) {
              $('#user-password-text').html('Weak ');
            } else if (passwordStrength < 8) {
              $('#user-password-text').html('Medium ');
            } else {
              $('#user-password-text').html('Strong ');
            }
        } else {
            $.fn.pStrength('resetStyle', this);
        }
        $('#' + $(this).data('display')).html('Your password strength is ' + strengthPercentage + '%');
      },
      'onValidatePassword': function(strengthPercentage) {
        $('#' + $(this).data('display')).html(
            $('#' + $(this).data('display')).html() + ' Great, now you can continue to register!'
        );
      }
    });
  });
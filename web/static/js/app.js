// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
// alert('webpack compiled me.');
// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

$('.ui.dropdown')
  .dropdown();

$('.secondary .item').tab();

$('.ui.form')
  .form({
    fields: {
      membership_category: {
        identifier: 'membership_category[membership_category_name]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter membership category'
          }
        ]
      },
      membership_type: {
        identifier: 'membership_type[membership_type_name]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter membership type'
          }
        ]
      },
      default_price_membership_category_id: {
        identifier: 'default_price[membership_category_id]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please select membership category'
          }
        ]
      },
      default_price_annual_price: {
        identifier: 'default_price[annual_price]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter annual price'
          }
        ]
      },
      payment_type_name: {
        identifier: 'payment_type[name]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter payment type'
          }
        ]
      },
      // In events admin page
      voucher_expire_at_day: {
        identifier: 'voucher[expire_at][day]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter day'
          }
        ]
      },
      voucher_expire_at_year: {
        identifier: 'voucher[expire_at][year]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter year'
          }
        ]
      },
      voucher_expire_at_month: {
        identifier: 'voucher[expire_at][month]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter month'
          }
        ]
      },
      voucher_expire_at_hour: {
        identifier: 'voucher[expire_at][hour]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter hour'
          }
        ]
      },
      voucher_expire_at_minute: {
        identifier: 'voucher[expire_at][minute]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter minute'
          }
        ]
      },
      voucher_discount_percent: {
        identifier: 'voucher[discount_percent]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter discount'
          },
          {
            type: 'number',
            prompt: 'Must be number'
          }
        ]
      },
      // In edit event admin page
      event_active_from_day: {
        identifier: 'event[active_from][day]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter day'
          }
        ]
      },
      event_active_from_year: {
        identifier: 'event[active_from][year]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter year'
          }
        ]
      },
      event_active_from_month: {
        identifier: 'event[active_from][month]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter month'
          }
        ]
      },
      event_active_from_hour: {
        identifier: 'event[active_from][hour]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter hour'
          }
        ]
      },
      event_active_from_minute: {
        identifier: 'event[active_from][minute]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter minute'
          }
        ]
      },
      event_active_to_day: {
        identifier: 'event[active_to][day]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter day'
          }
        ]
      },
      event_active_to_year: {
        identifier: 'event[active_to][year]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter year'
          }
        ]
      },
      event_active_to_month: {
        identifier: 'event[active_to][month]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter month'
          }
        ]
      },
      event_active_to_hour: {
        identifier: 'event[active_to][hour]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter hour'
          }
        ]
      },
      event_active_to_minute: {
        identifier: 'event[active_to][minute]',
        rules: [
          {
            type   : 'empty',
            prompt : 'Please enter minute'
          }
        ]
      },
    }
  });

  $('.modal')
  .modal('show');

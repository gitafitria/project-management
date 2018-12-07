# window

ready = ->

  if $("#project_chart").length > 0
    Morris.Line
      element: 'project_chart'
      data: $('#project_chart').data('project')
      xkey: 'month_name'
      ykeys: ['total']
      labels: ['Total']
      xLabels: "month"
      parseTime: false
      resize: true

  if $("#invoice_chart").length > 0
    Morris.Bar
      element: 'invoice_chart'
      data: $('#invoice_chart').data('invoice')
      xkey: 'project'
      ykeys: ['total']
      labels: ['Total']
      xLabels: "project"
      parseTime: false
      barColors: ['#77dda2']
      resize: true
      # barColors: ['#E8B03D']

$(document).ready(ready);
$(document).on('page:change', ready);
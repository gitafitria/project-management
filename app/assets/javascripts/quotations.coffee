window.quotationDataTablesLoad = () ->
  url = $(".quotation-table").data('url')
  $(".quotation-table").DataTable
    'destroy': true
    'searching': true
    'ajax':
      'url': url
      'data': filterFormSerializeJson($("#form_filter_quotation_data"))
    'processing': true
    'serverSide': true
    'fnDrawCallback': ->
      $(".quotation-modal").modal('hide')
      return
      #   # show data table to the top of page when switch pagination
      #   $('html, body').animate { scrollTop: $('body').offset().top }, 'slow'
      #   filterDataOption()
      #   updateExportFilter()
      #   showHideTableColumn()
      #   isolateFilterLabel()
      #   $('.new-slide-panel').css 'display', 'none'
      #   checkIt()
      #   tooltipAndPopoverShow()
      #   # counterCheck()
    'aoColumnDefs': [ {
      'bSortable': false
      'aTargets': [
        'col-options-column'
      ]
    } ]
    start: 0

window.quotationDataTablesReset = () ->
  table = quotationDataTablesLoad()
  table.ajax.reload()


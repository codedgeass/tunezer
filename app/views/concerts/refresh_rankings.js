$('.rankings_list').html('<%= escape_javascript render partial: 'rankings', 
  locals: { selected_size: params[:size], selected_sorting: params[:sort] } %>');
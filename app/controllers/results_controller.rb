class ResultsController < ApplicationController

  def index
    @sets = ResultsZip.all.to_a.sort_by(&:created_at).reverse
  end

  def download
    set = ResultsZip.find(params[:readme_id])
    send_data set.zip_to_download, filename: set.filename, type: 'application/octet-stream'
  end

  def search_form; end

  def search
    type = 'readmes'
    results = ResultsZip.create! query: params[:q], type: type
    ResultsZipCreatorWorker.perform_async results.id, type
    redirect_to results_path
  end
end
module RequestStubs

  def stub_completion_rate_returns
    stub_post_success("https://www.performance.service.gov.uk/data/advocate-defence-payments-agfs/completion-rate")
  end

  def stub_transactions_by_channel_returns
    stub_post_success("https://www.performance.service.gov.uk/data/advocate-defence-payments-agfs/transactions-by-channel")
  end

  def stub_all_posts_with_success
    stub_post_success(%r{\Ahttps://www.performance.service.gov.uk/data/advocate-defence-payments-agfs/.*\z})
  end

private

  def stub_post_success(url)
    stub_request(
      :post,
      url
    ).to_return(
      status:   200,
      headers: { :content_type => :json, :accept => :json },
      body:   { status: "ok" }.to_json
    )
  end

end

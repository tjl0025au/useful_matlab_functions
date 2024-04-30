function butterworth_filtered_signal = churn(input_signal,filter_order,bandwidth)

[b,a] = butter(filter_order,bandwidth);

butterworth_filtered_signal = filter(b,a,input_signal);
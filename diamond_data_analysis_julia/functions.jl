function plot_categorical_distribution(df::DataFrame, column::Symbol; color="Deep Sky Blue")
    # Create a frequency table for the categorical column
    freq_table = freqtable(df[:, column])
    
    # Extract labels and counts directly from the frequency table
    labels = String.(names(freq_table)[1])
    counts = collect(skipmissing(freq_table))
    
    # Create a bar plot
    p = bar(labels, counts, xlabel=String(column), ylabel="Frequency", 
            title="Distribution of " * String(column), legend=false, fill=color, size=(500, 300))
    return p
end

function create_qq_plot(df::DataFrame, column::Symbol)
    data = df[:, column]
    qqplot(Normal(), data, qqline = :R, 
        title = "QQ-Plot of " * string(column),
        xlabel = "Theoretical Quantiles",
        ylabel = "Sample Quantiles"
    )
end

function plot_histogram_violin(df::DataFrame, column::Symbol; bins=10)
    data = df[:, column]
    
    # Create the histogram
    p1 = histogram(data, bins=bins, title="Histogram of " * String(column), 
                   xlabel=String(column), ylabel="Frequency", size=(100, 50), legend=false)
    
    # Create the violin plot
    p2 = @df df violin([String(column)], data, title="Violin Plot of " * String(column),
                       xlabel=String(column), ylabel="Value", legend=false, fill="Dark Salmon")
    
    # Combine the two plots
    p = plot(p1, p2, layout=(1, 2), size=(1000, 350), legend=false)
    return p
end

function plot_density(df::DataFrame, column::Symbol)
    data = df[:, column]
    @df df density(data, xlabel=String(column), ylabel="Density", 
                   title="Density Plot of " * String(column), legend=false)
end

function plot_violin(df::DataFrame, column::Symbol)
    data = df[:, column]
    @df df violin([String(column)], data, xlabel=String(column), ylabel="Value",
                  title="Violin Plot of " * String(column), legend=false)
end

function percentile_analysis(df::DataFrame, column::Symbol; percentiles=[0.25, 0.5, 0.75, 0.9, 0.95, 0.99])
    data = df[:, column]
    percentile_values = quantile(data, percentiles)
    percentile_values = quantile(data, percentiles)
    result = DataFrame(Percentile=percentiles, Value=percentile_values)
    return result
end

function compute_correlation_matrix(df::DataFrame)
    # Select numerical columns
    numerical_df = select(df, Not(:Cut, :Color, :Clarity))
    
    # Get feature names
    feature_names = names(numerical_df)
    
    # Convert DataFrame to Matrix
    matrix_data = Matrix(numerical_df)
    
    # Compute correlation matrix
    cor_matrix = cor(matrix_data)
    
    # Convert correlation matrix to DataFrame
    cor_df = DataFrame(cor_matrix, feature_names)
    
    # Insert a new column for feature names
    insertcols!(cor_df, 1, :Feature => feature_names)
    
    return cor_df
end

function aggregated_plot(df::DataFrame, numerical_col::Symbol, categorical_col::Symbol)
    # Grouping the data by the categorical variable and computing median and standard deviation
    aggregated_data = combine(groupby(df, categorical_col), 
        numerical_col => median => :median,
        numerical_col => std => :std
    )

    # Sorting the aggregated data for better visualization
    sort!(aggregated_data, :median)

    # Plotting
    p = plot(
        aggregated_data[!, categorical_col],
        aggregated_data[!, :median],
        yerr = aggregated_data[!, :std],
        seriestype = :scatter,
        legend = false,
        xlabel = string(categorical_col),
        ylabel = string(numerical_col),
        title = "Median and Standard Deviation of " * string(numerical_col) * " by " * string(categorical_col)
    )
    
    return p
end

function aggregate_medians(df::DataFrame, group_col::Symbol)
    grouped_data = groupby(df, group_col)
    median_data = combine(grouped_data, :Price => median => :MedianPrice, :Carat => median => :MedianCarat)
    return median_data
end

function get_order(label::String, cat_variable::Symbol)
    if cat_variable == :Cut
        return findfirst(isequal(label), cut_order)
    elseif cat_variable == :Color
        return findfirst(isequal(label), color_order)
    elseif cat_variable == :Clarity
        return findfirst(isequal(label), clarity_order)
    else
        error("Unknown categorical variable: ", cat_variable)
    end
end

function create_violin_boxplot(dataset::DataFrame, num_variable::Symbol, cat_variable::Symbol)
    # Function to pass to sort_labels_by
    order_func = label -> get_order(label, cat_variable)

    @df dataset boxplot(
        string.(getproperty(dataset, cat_variable)), 
        getproperty(dataset, num_variable), 
        outliers=false, 
        fillalpha=.80, 
        linewidth=1, 
        sort_labels_by=order_func, 
        title="Boxplot and Violin plot of $(string(num_variable)) by $(string(cat_variable))", 
        xlabel=string(cat_variable), 
        ylabel=string(num_variable)
    )
    @df dataset violin!(
        string.(getproperty(dataset, cat_variable)), 
        getproperty(dataset, num_variable), 
        trim=true, 
        linewidth=0, 
        fillalpha=.20, 
        legend=false
    )
end
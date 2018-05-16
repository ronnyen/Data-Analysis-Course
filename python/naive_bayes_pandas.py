import pandas as pd
import numpy as np
import math

df = pd.read_csv("pima-indians-diabetes.data3.csv", header=None)

# # f(x) = (1/s(2m)^0.5)*e
# # e = e^((x-m)^2/(2s^2))
def calculateProbability(x, mean, stdev):
    exponent = math.exp(-(math.pow(x-mean, 2)/(2*math.pow(stdev, 2))))
    return (1 / (math.sqrt(2*math.pi) * stdev)) * exponent

def calculate_multi_prob(row, mean_df, std_df):
    """
    This function calculates the multiplication of all probabilities per class.
    Will be used in df.apply
    :param row: row of pandas dataframe
    :param mean_df: pandas dataframe of mean per class, per attribute
    :param std_df: pandas dataframe of std per class, per attribute
    :return: the multiplication of probabilities per class
    """
    class_list = mean_df.columns
    attr_list = mean_df.index
    multi_prob = [1] * len(class_list)
    for attr_num in attr_list:
        for ix, class_num in enumerate(class_list):
            prob = calculateProbability(row[attr_num], mean_df[class_num].loc[attr_num], std_df[class_num].loc[attr_num])
            multi_prob[ix] *= prob
    max_prob_ix = np.argmax(multi_prob)
    return class_list[max_prob_ix]


def row_accuracy(row, class_column):
    if row[class_column] == row['predicted_class']:
        return 1
    return 0

def naive_bayes(dataset, class_column, split_ratio):
    train = dataset.sample(frac=split_ratio, random_state=200)
    test = dataset.drop(train.index)
    mean = train.groupby(class_column).mean().transpose()
    std = train.groupby(class_column).std().transpose()
    test['predicted_class'] = test.apply(calculate_multi_prob, axis=1, args=(mean, std,))
    test['is_correct'] = test.apply(row_accuracy, axis=1, args=(class_column,))
    accuracy = test['is_correct'].sum() / len(test)
    return accuracy

accuracy_result = naive_bayes(df, 8, 0.67)
print('accuracy\n', accuracy_result)



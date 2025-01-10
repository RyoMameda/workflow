#!/usr/bin/env python3

import pandas as pd
import argparse

def process_data(input_file, output_file):
    # ファイルAを読み込む
    data = pd.read_csv(input_file, sep='\t', header=None, skiprows=2)
    data_filtered = data[~data[0].str.startswith('rRNA')]

    # 1列目、6列目、および最後の列を取得
    col1 = data_filtered[0]
    col6 = data_filtered[5]
    last_col = data_filtered[data_filtered.columns[-1]]

    # Tgeneを計算
    Tgene = ((last_col + 1) / col6) * 1000

    # Tsumを計算
    Tsum = Tgene.sum()

    # TPMを計算
    TPM = (Tgene / Tsum) * 1000000

    # 出力データフレームを作成
    output_data = pd.DataFrame({
        'Geneid': col1,
        'TPM': TPM
    })

    # ファイルBに書き出し
    sorted_output_data=output_data.sort_values(by=output_data.columns[1], ascending=False)
    sorted_output_data.to_csv(output_file, sep='\t', index=False)

def main():
    # 引数のパーサーを作成
    parser = argparse.ArgumentParser(description='Read counts data into GPM')
    parser.add_argument('--mg', required=True, help='featureCounts output text file for metagenomic reads')
    parser.add_argument('--gpm', required=True, help='GPM counted file')

    # 引数を解析
    args = parser.parse_args()

    # スクリプトを実行
    process_data(args.mg, args.gpm)

if __name__ == '__main__':
    main()

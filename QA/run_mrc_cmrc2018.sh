#!/usr/bin/env bash

CURRENT_DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
export MODEL_NAME=roberta_wwm_large
export OUTPUT_DIR=$CURRENT_DIR/check_points
export BERT_DIR=robert
export GLUE_DIR=$CURRENT_DIR/mrc_data # set your data dir
TASK_NAME="CMRC2018"

python run_mrc.py \
  --gpu_ids="0,1,2" \
  --train_epochs=2 \
  --n_batch=18 \
  --lr=3e-5 \
  --warmup_rate=0.1 \
  --max_seq_length=512 \
  --max_ans_length=200\
  --task_name=$TASK_NAME \
  --vocab_file=$BERT_DIR/vocab.txt \
  --bert_config_file=$BERT_DIR/bert_config.json \
  --init_restore_dir=$BERT_DIR/pytorch_model.pth \
  --train_dir=$GLUE_DIR/$TASK_NAME/train_features.json \
  --train_file=$GLUE_DIR/$TASK_NAME/train_squad.json \
  --dev_dir1=$GLUE_DIR/$TASK_NAME/dev_examples.json \
  --dev_dir2=$GLUE_DIR/$TASK_NAME/dev_features.json \
  --dev_file=$GLUE_DIR/$TASK_NAME/dev_squad.json \
  --checkpoint_dir=$OUTPUT_DIR/$TASK_NAME/$MODEL_NAME/

python test_mrc.py \
  --gpu_ids="0,1,2" \
  --n_batch=18 \
  --max_seq_length=512 \
  --task_name=$TASK_NAME \
  --vocab_file=$BERT_DIR/vocab.txt \
  --bert_config_file=$BERT_DIR/bert_config.json \
  --init_restore_dir=$OUTPUT_DIR/$TASK_NAME/$MODEL_NAME/ \
  --output_dir=$OUTPUT_DIR/$TASK_NAME/$MODEL_NAME/ \
  --test_dir1=$GLUE_DIR/$TASK_NAME/test_examples.json \
  --test_dir2=$GLUE_DIR/$TASK_NAME/test_features.json \
  --test_file=$GLUE_DIR/$TASK_NAME/cmrc2018_test_2k.json \




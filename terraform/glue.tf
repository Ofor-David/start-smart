resource "aws_glue_catalog_database" "event_lake_db" {
  name = "event_lake_db"
}

resource "aws_glue_crawler" "event_crawler" {
  depends_on = [ aws_iam_role_policy.glue_crawler_policy ]
  name          = "event-lake-crawler"
  role          = aws_iam_role.glue_crawler_role.id
  database_name = aws_glue_catalog_database.event_lake_db.name
  description   = "crawls enriched json events from s3 and catalogs them"

  s3_target {
    path = "s3://${aws_s3_bucket.event_lake.bucket}/events/"
  }

  table_prefix = "event_" # start tables with ...

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING" # TODO: Crawl everything for now, optimise later
  }

  configuration = jsonencode ({
    Version = 1.0,
    Grouping = {
      TableGroupingPolicy = "CombineCompatibleSchemas"
    }
    CrawlerOutput = {
      Partitions = {
        AddOrUpdateBehavior = "InheritFromTable"
      }
    }
  })
}

resource "aws_glue_trigger" "crawler_trigger" {
  name     = "daily-crawler-trigger"
  type     = "SCHEDULED"
  schedule = var.execution_frequency  # Every day at 6 AM UTC

  actions {
    crawler_name = aws_glue_crawler.event_crawler.name
  }

  start_on_creation = true
}


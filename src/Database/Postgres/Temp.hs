{-|
This module provides functions for creating a temporary @postgres@ instance.
By default it will create a temporary data directory and
a temporary directory for a UNIX domain socket for @postgres@ to listen on in addition to
listening on @127.0.0.1@ and @::1@.

Here is an example using the expection safe 'with' function:

 @
 'with' $ \\db -> 'Control.Exception.bracket'
    ('PG.connectPostgreSQL' ('toConnectionString' db))
    'PG.close' $
    \\conn -> 'PG.execute_' conn "CREATE TABLE foo (id int)"
 @

To extend or override the defaults use `withConfig` (or `startConfig`).

@tmp-postgres@ ultimately calls (optionally) @initdb@, @postgres@ and
(optionally) @createdb@.

All of the command line, environment variables and configuration files
that are generated by default for the respective executables can be
extended.

In general @tmp-postgres@ is useful if you want a clean temporary
@postgres@ and do not want to worry about clashing with an existing
postgres instance (or needing to ensure @postgres@ is already running).

Here are some different use cases for @tmp-postgres@ and their respective
configurations:

* The default 'with' and 'start' functions can be used to make a sandboxed
temporary database for testing.
* By disabling @initdb@ one could run a temporary
isolated postgres on a base backup to test a migration.
* By using the 'stopPostgres' and 'withRestart' functions one can test
backup strategies.

WARNING!!
Ubuntu's PostgreSQL installation does not put @initdb@ on the @PATH@. We need to add it manually.
The necessary binaries are in the @\/usr\/lib\/postgresql\/VERSION\/bin\/@ directory, and should be added to the @PATH@

 > echo "export PATH=$PATH:/usr/lib/postgresql/VERSION/bin/" >> /home/ubuntu/.bashrc

-}

module Database.Postgres.Temp
  (
  -- * Exception safe interface
    with
  , withConfig
  , withRestart
  , withDbCache
  , withDbCacheConfig
  , withSnapshot
  -- * Separate start and stop interface.
  , start
  , startConfig
  , stop
  , restart
  , stopPostgres
  , stopPostgresGracefully
  , setupInitDbCache
  , cleanupInitDbCache
  , takeSnapshot
  , cleanupSnapshot
  -- * Main resource handle
  , DB
  -- ** 'DB' accessors
  , toConnectionString
  , toConnectionOptions
  , toDataDirectory
  , toTemporaryDirectory
  -- ** 'DB' modifiers
  , makeDataDirPermanent
  , reloadConfig
  -- ** 'DB' debugging
  , prettyPrintDB
  -- ** 'Snapshot' handle
  , Snapshot
  -- ** @initdb@ cache handle
  , CacheResources
  -- * Errors
  , StartError (..)
  -- * Configuration
  -- ** Defaults
  , defaultConfig
  , defaultPostgresConf
  , standardProcessConfig
  , silentConfig
  , silentProcessConfig
  , defaultCacheConfig
  , snapshotConfig
  -- ** Custom Config builder helpers
  , optionsToDefaultConfig
  -- ** Configuration Types
  -- *** 'CacheConfig'
  , CacheConfig (..)
  -- *** General Configuration Types
  , module Database.Postgres.Temp.Config
  ) where
import Database.Postgres.Temp.Internal
import Database.Postgres.Temp.Internal.Core
import Database.Postgres.Temp.Config
import Database.Postgres.Temp.Internal.Config
  (standardProcessConfig, silentProcessConfig)

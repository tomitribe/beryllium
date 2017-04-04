/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.tomitribe.beryllium.internal.logging;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.event.Level;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;

public class LoggerPrintStream extends PrintStream {

  public LoggerPrintStream(Logger logger, Level level) {
    super(new LoggerOutputStream(logger, level), true);
  }

  private static class LoggerOutputStream extends OutputStream {

    private final Logger logger;
    private final Level level;
    private StringBuilder stringBuilder = new StringBuilder();

    LoggerOutputStream(Logger logger, Level level) {
      this.logger = logger;
      this.level = level;
    }

    @Override
    public void write(int b) throws IOException {
      stringBuilder.append((char) b);
    }

    @Override
    public void flush() {
      log(logger, level, stringBuilder.toString());
      stringBuilder = new StringBuilder();
    }

    private void log(Logger logger, Level level, String message) {

      if (StringUtils.isBlank(message)) return;

      switch (level) {
        case TRACE:
          logger.trace(message);
          break;
        case DEBUG:
          logger.debug(message);
          break;
        case INFO:
          logger.info(message);
          break;
        case WARN:
          logger.warn(message);
          break;
        case ERROR:
          logger.error(message);
          break;
        default:
          logger.info(message);
          break;
      }
    }
  }

}
